defmodule Lightning.MixProject do
  use Mix.Project

  def project do
    [
      app: :lightning,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
     
      # Docs
      name: "Lightning",
      source_url: "https://github.com/casperCX/lightning",
      homepage_url: "https://github.com/casperCX/lightning",
      docs: [
        main: "Lightning.HTTP", 
        logo: "./lightning_logo_small.png",
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

  defp description() do
    "Library for making simple REST API endpoints based on Plug"
  end

    defp package() do
    %{
      licenses: ["Apache 2"],
      maintainers: ["Casper Groenenberg"],
      links: %{"GitHub" => "https://github.com/casperCX/lightning"},
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE"]
    }
  end
end
