defmodule PeppermintPatty.File do
  alias __MODULE__, as: PattyFile
  alias PeppermintPatty.HttpClient

  @callback open(String.t()) :: {:ok, binary()} | {:ok, stream :: map()} | {:error, any()}

  @type file :: PattyFile.Stream | PattyFile.InMemory

  @default_chunk_size 2048

  @spec open(String.t()) :: {:ok, file()} | {:error, any()}
  def open(uri) do
    case URI.new(uri) do
      {:ok, parsed_uri} -> open_by_proto(uri, parsed_uri.scheme)
      {:error, _} -> {:error, :invalid_uri}
    end
  end

  defp open_by_proto(url, protocol) when protocol in ["http", "https"] do
    case HttpClient.open(url) do
      {:ok, body} when is_binary(body) -> {:ok, %PattyFile.InMemory{content: body}}
      {:ok, stream} when is_struct(stream) -> {:ok, %PattyFile.Stream{stream: stream}}
      {:error, _reason} = error -> error
    end
  end

  defp open_by_proto(url, nil) do
    chunk_size = local_file_chunk_size()
    File.stream!(url, [], chunk_size)
  end

  def local_file_chunk_size do
    :peppermint_patty
    |> Application.get_env(__MODULE__, [])
    |> Keyword.get(:chunk_size, @default_chunk_size)
  end
end
