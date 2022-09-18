defmodule PeppermintPatty.File do
  alias __MODULE__, as: PattyFile
  alias PeppermintPatty.HttpClient

  @type file :: PattyFile.Stream | PattyFile.InMemory

  @spec open(String.t()) :: {:ok, file()} | {:error, any()}
  def open("http" <> _ = url) do
    case HttpClient.open(url) do
      {:ok, body} when is_binary(body) -> {:ok, %PattyFile.InMemory{content: body}}
      {:ok, stream} when is_struct(stream) -> {:ok, %PattyFile.Stream{stream: stream}}
      {:error, _reason} = error -> error
    end
  end
end
