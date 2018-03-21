defmodule GoogleSpanner.MixProject do
  use Mix.Project

  def project do
    [
      app: :google_spanner,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Generate and retrieve Oauth2 tokens for use with Google Cloud Service accounts.
      {:goth, "~> 0.8.0"},
      # HTTP client library, with support for middleware and multiple adapters.
      {:tesla, "~> 0.10.0"},
      # Pure Elixir JSON library (Required by Tesla JSON middleware)
      {:poison, "~> 3.1"},
      # Generic working pooling library
      {:poolboy, "~> 1.5.1"},
    ]
  end
end
