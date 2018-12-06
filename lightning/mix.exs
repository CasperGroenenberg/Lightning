defmodule Lightning.MixProject do
  use Mix.Project

  def project do
    [
      app: :lightning,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :ecto, :plug_cowboy, :plug]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:plug_cowboy, "~> 2.0"},
    {:poison, "~> 3.1"},
    {:plug, "~> 1.7"},
    {:ecto, "~> 2.2.9"}]
  end
end
