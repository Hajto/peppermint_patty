defmodule PeppermintPatty.File do
  alias __MODULE__, as: PattyFile
  alias PeppermintPatty.HttpClient

  @callback open(String.t()) :: {:ok, binary()} | {:ok, stream :: map()} | {:error, any()}

  @type file :: PattyFile.Stream | PattyFile.InMemory

  @default_chunk_size 2048

  @doc """
  Opens an image.

  Depending on the uri:
   - remote resources will be fetched, f.e. remote image will be downloaded
   - local file will be opened
  """
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
    if File.exists?(url) do
      chunk_size = local_file_chunk_size()
      stream = File.stream!(url, [], chunk_size)
      {:ok, %PattyFile.Stream{stream: stream}}
    else
      {:error, :enoent}
    end
  end

  @spec local_file_chunk_size :: pos_integer()
  def local_file_chunk_size do
    :peppermint_patty
    |> Application.get_env(__MODULE__, [])
    |> Keyword.get(:chunk_size, @default_chunk_size)
  end

  @spec save(file(), String.t()) :: :ok | {:error, reason :: any()}
  def save(file, path), do: PeppermintPatty.FileOps.save(file, path)
end

defprotocol PeppermintPatty.FileOps do
  @spec save(t, String.t()) :: :ok | {:error, reason :: any()}
  def save(patty_file, path)
end
