import Config

config :ex_aws, :s3,
  scheme: "http://",
  host: System.get_env("S3_HOST", "localhost"),
  port: 4566,
  region: "us-west-2",
  access_key_id: "123",
  secret_access_key: "123"
