defmodule PeppermintPatty.MixProject do
  use Mix.Project

  def project do
    [
      app: :peppermint_patty,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, github: "elixir-tesla/tesla", branch: "tt/finch-stream"},

      # Storage solutions
      {:ex_aws, "~> 2.1", optional: true},
      {:ex_aws_s3, "~> 2.0", optional: true},
      {:hackney, "~> 1.9", optional: true, only: [:dev]},
      {:jason, "~> 1.4.0", only: [:dev]}
    ]
  end
end
