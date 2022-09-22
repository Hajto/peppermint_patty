import Config

config :tesla, PeppermintPatty.HttpClient.DefaultTeslaClient, adapter: Tesla.Mock
config :peppermint_patty, PeppermintPatty.Storage.S3, ex_aws: ExAwsMock
