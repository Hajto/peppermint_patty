defmodule PeppermintPatty.File.InMemory do
  @enforce_keys [:content]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          content: binary()
        }
end

defimpl PeppermintPatty.FileOps, for: PeppermintPatty.File.InMemory do
  @spec save(PeppermintPatty.File.InMemory.t(), String.t()) :: :ok | {:error, File.posix()}
  def save(%PeppermintPatty.File.InMemory{content: content}, path) do
    File.write(path, content)
  end
end
