defmodule PeppermintPatty.HttpClient do
  @moduledoc """
  This module provides functionality to resolve HTTP and HTTPS resources.

  By default it uses built in Tesla client, which can be configured with adapter.
  Uses Finch by default to take advantage of response streaming.

  ## Configuration

  - `:tesla_client` - points to Tesla client that will be used for fetching images. The client
  will dictate retry and timeout algorithm.
  ```
  config :peppermint_patty, PeppermintPatty.HttpClient
    tesla_client: YourClientModuleName
  ```
  """
  @behaviour PeppermintPatty.File

  defmodule DefaultTeslaClient do
    @doc false
    use Tesla
  end

  @doc """
  Opens remote file results in either downloaded binary
  or a stream if adapter supports that.
  """
  @impl true
  def open(url) do
    case client().get(url, opts: [adapter: [response: :stream]]) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body}
      # TODO: Proper error handling
      {:ok, %Tesla.Env{} = erroneous_response} -> {:error, erroneous_response}
      {:error, _reason} = error -> error
    end
  end

  @spec client :: module()
  def client do
    :peppermint_patty
    |> Application.get_env(__MODULE__, [])
    |> Keyword.get(:tesla_client, DefaultTeslaClient)
  end
end
