defmodule PeppermintPatty.Storage do
  @callback store(file :: map(), path :: String.t(), opts :: Keyword.t()) ::
              :ok | {:error, reason :: any()}
  @callback delete(path :: String.t(), opts :: Keyword.t()) :: :ok | {:error, reason :: any()}
end
