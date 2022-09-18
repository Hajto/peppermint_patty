defmodule PeppermintPatty.HttpClient do
  defmodule DefaultTeslaClient do
    @doc false
    use Tesla
  end

  @doc """
  Opens remote file results in either downloaded binary
  or a stream if adapter supports that.
  """
  @spec open(String.t()) :: {:ok, binary()} | {:ok, stream :: map()} | {:error, any()}
  def open(url) do
    case client().get(url, opts: [adapter: [response: :stream]]) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body}
      # TODO: Proper error handling
      {:ok, %Tesla.Env{} = erronous_response} -> {:error, erronous_response}
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
