defmodule PeppermintPatty.Storage.S3Test do
  use ExUnit.Case, async: true

  describe "store/3" do
    test "calls storeable protocol to store object on AWS"
    test "calls delete_object on AWS and responds with :ok if object is deleted"
    test "calls delete_object on AWS and returns an error if object is not deleted"
  end

  defp success_response do
    %{
      body: "",
      headers: [
        {"Content-Type", "text/html; charset=utf-8"},
        {"Content-Length", "0"},
        {"ETag", "\"202cb962ac59075b964b07152d234b70\""},
        {"last-modified", "Sun, 18 Sep 2022 16:14:57 GMT"},
        {"x-amzn-requestid", "PPWLA2PW3YUK6BSMLDEH5T4W1RLQ6NVO8KC48SPZETSZKTYGV2F4"},
        {"Access-Control-Allow-Origin", "*"},
        {"Connection", "close"},
        {"Location", "http://bucket.s3.localhost.localstack.cloud:4566/"},
        {"x-amz-request-id", "DBFDA13BD4727549"},
        {"x-amz-id-2", "MzRISOwyjmnupDBFDA13BD47275497/JypPGXLh0OVFGcJaaO3KW/hRAqKOpIEEp"},
        {"Access-Control-Allow-Methods", "HEAD,GET,PUT,POST,DELETE,OPTIONS,PATCH"},
        {"Access-Control-Allow-Headers",
         "authorization,cache-control,content-length,content-md5,content-type,etag,location,x-amz-acl,x-amz-content-sha256,x-amz-date,x-amz-request-id,x-amz-security-token,x-amz-tagging,x-amz-target,x-amz-user-agent,x-amz-version-id,x-amzn-requestid,x-localstack-target,amz-sdk-invocation-id,amz-sdk-request"},
        {"Access-Control-Expose-Headers", "etag,x-amz-version-id"},
        {"date", "Sun, 18 Sep 2022 16:14:57 GMT"},
        {"server", "hypercorn-h11"}
      ],
      status_code: 200
    }
  end

  defp error_response do
    body = %{
      body:
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Error><Code>NoSuchBucket</Code><Message>The specified bucket does not exist</Message><BucketName>non-existant-bucket</BucketName><RequestID>7a62c49f-347e-4fc4-9331-6e8eEXAMPLE</RequestID></Error>",
      headers: [
        {"Content-Type", "application/xml; charset=utf-8"},
        {"Content-Length", "228"},
        {"x-amzn-requestid", "MHUS2GCAJX2NMT12IF9W7UQVPIQKF66ASA04G2AH9FDAH7K0WDVN"},
        {"Access-Control-Allow-Origin", "*"},
        {"Connection", "close"},
        {"Location", "http://non-existant-bucket.s3.localhost.localstack.cloud:4566/"},
        {"Last-Modified", "Sun, 18 Sep 2022 16:12:59 GMT"},
        {"x-amz-request-id", "6C4F1E2820DED060"},
        {"x-amz-id-2", "MzRISOwyjmnup6C4F1E2820DED0607/JypPGXLh0OVFGcJaaO3KW/hRAqKOpIEEp"},
        {"Access-Control-Allow-Methods", "HEAD,GET,PUT,POST,DELETE,OPTIONS,PATCH"},
        {"Access-Control-Allow-Headers",
         "authorization,cache-control,content-length,content-md5,content-type,etag,location,x-amz-acl,x-amz-content-sha256,x-amz-date,x-amz-request-id,x-amz-security-token,x-amz-tagging,x-amz-target,x-amz-user-agent,x-amz-version-id,x-amzn-requestid,x-localstack-target,amz-sdk-invocation-id,amz-sdk-request"},
        {"Access-Control-Expose-Headers", "etag,x-amz-version-id"},
        {"date", "Sun, 18 Sep 2022 16:12:59 GMT"},
        {"server", "hypercorn-h11"}
      ],
      status_code: 404
    }

    {:error, {:http_error, 404, body}}
  end

  defp error_upload do
    response = %{
      body:
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Error><Code>EntityTooSmall</Code><Message>Your proposed upload is smaller than the minimum allowed object size.</Message><RequestID>7a62c49f-347e-4fc4-9331-6e8eEXAMPLE</RequestID></Error>",
      headers: [
        {"Content-Type", "application/xml; charset=utf-8"},
        {"Content-Length", "227"},
        {"x-amzn-requestid", "G6FMYKKHC26EJHCO338MLNTE2Y68XOB5S3VEUONT8K4VWRWE7SBN"},
        {"Access-Control-Allow-Origin", "*"},
        {"Connection", "close"},
        {"Last-Modified", "Sun, 18 Sep 2022 16:39:12 GMT"},
        {"x-amz-request-id", "1D78DB0EEBDD32B7"},
        {"x-amz-id-2", "MzRISOwyjmnup1D78DB0EEBDD32B77/JypPGXLh0OVFGcJaaO3KW/hRAqKOpIEEp"},
        {"Access-Control-Allow-Methods", "HEAD,GET,PUT,POST,DELETE,OPTIONS,PATCH"},
        {"Access-Control-Allow-Headers",
         "authorization,cache-control,content-length,content-md5,content-type,etag,location,x-amz-acl,x-amz-content-sha256,x-amz-date,x-amz-request-id,x-amz-security-token,x-amz-tagging,x-amz-target,x-amz-user-agent,x-amz-version-id,x-amzn-requestid,x-localstack-target,amz-sdk-invocation-id,amz-sdk-request"},
        {"Access-Control-Expose-Headers", "etag,x-amz-version-id"},
        {"date", "Sun, 18 Sep 2022 16:39:12 GMT"},
        {"server", "hypercorn-h11"}
      ],
      status_code: 400
    }

    {:error, {:http_error, 400, response}}
  end
end
