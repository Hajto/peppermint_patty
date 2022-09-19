defmodule PeppermintPatty.MixProject do
  use Mix.Project

  def project do
    [
      app: :peppermint_patty,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, github: "elixir-tesla/tesla", branch: "tt/finch-stream"},

      # Test deps
      {:mox, "~> 1.0", only: :test},

      # Storage solutions
      {:ex_aws, "~> 2.1", optional: true},
      {:ex_aws_s3, "~> 2.0", optional: true},
      {:hackney, "~> 1.9", optional: true, only: [:dev]},
      {:jason, "~> 1.4.0", only: [:dev], optional: true},
      {:sweet_xml, "~> 0.6", only: [:dev], optional: true}
    ]
  end
end
