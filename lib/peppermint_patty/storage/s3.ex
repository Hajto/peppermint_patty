if Code.ensure_loaded?(ExAws.S3) do
  defmodule PeppermintPatty.Storage.S3 do
    @behaviour PeppermintPatty.Storage

    @ex_aws ExAws

    alias PeppermintPatty.Storage

    @impl Storage
    def store(file, path, opts) do
      bucket = Keyword.fetch!(opts, :bucket)

      file
      |> PeppermintPatty.Storage.S3.Storeable.store(bucket, path)
      |> @ex_aws.request()
      |> case do
        {:ok, %{status_code: 200}} ->
          :ok
        {:error, _reason} = error ->
          error
      end
    end

    @impl Storage
    def delete(path, opts) do
      bucket = Keyword.fetch!(opts, :bucket)

      bucket
      |> ExAws.S3.delete_object(path)
      |> @ex_aws.request()
      |> case do
        {:ok, _} -> :ok
        {:error, _reason} = error -> error
      end
    end
  end

  defprotocol PeppermintPatty.Storage.S3.Storeable do
    @spec store(t(), String.t(), String.t()) :: ExAws.Operation.t()
    def store(file, bucket, path)
  end

  defimpl PeppermintPatty.Storage.S3.Storeable, for: PeppermintPatty.File.Stream do
    @spec store(PeppermintPatty.File.Stream.t(), String.t(), String.t()) :: ExAws.S3.Upload.t()
    def store(%PeppermintPatty.File.Stream{stream: stream}, bucket, path) do
      ExAws.S3.upload(stream, bucket, path)
    end
  end

  defimpl PeppermintPatty.Storage.S3.Storeable, for: PeppermintPatty.File.InMemory do
    @spec store(PeppermintPatty.File.InMemory.t(), binary, binary) :: ExAws.Operation.S3.t()
    def store(%PeppermintPatty.File.InMemory{content: content}, bucket, path) do
      ExAws.S3.put_object(bucket, path, content)
    end
  end
end
