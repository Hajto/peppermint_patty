defmodule PeppermintPatty.File.InMemory do
  @enforce_keys [:content]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          content: binary()
        }
end
