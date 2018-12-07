defmodule Lightning.MixProject do
  use Mix.Project

  def project do
    [
      app: :lightning,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Lightning",
      source_url: "https://github.com/casperCX/lightning",
      homepage_url: "https://github.com/casperCX/lightning",
      docs: [
        main: "Lightning", 
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :plug_cowboy, :plug]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:ex_doc, "~> 0.18.0", only: :dev, runtime: false},
    {:plug_cowboy, "~> 2.0"},
    {:poison, "~> 3.1"},
    {:plug, "~> 1.7"}
    ]
  end
end
