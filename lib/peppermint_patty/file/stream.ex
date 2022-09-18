defmodule PeppermintPatty.File.Stream do
  @enforce_keys [:stream]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          # TODO: Figure out proper type spec
          stream: map()
        }
end
