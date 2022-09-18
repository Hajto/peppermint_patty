defmodule PeppermintPatty.File.Stream do
  @enforce_keys [:stream]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          # TODO: Figure out proper type spec
          stream: map()
        }
end

defimpl PeppermintPatty.FileOps, for: PeppermintPatty.File.Stream do
  @spec save(PeppermintPatty.File.Stream.t(), String.t()) :: :ok | {:error, File.posix()}
  def save(%PeppermintPatty.File.Stream{stream: stream}, path) do
    output_stream = File.stream!(path, [], PeppermintPatty.File.local_file_chunk_size())

    stream
    |> Stream.into(output_stream)
    |> Stream.run()
  end
end
