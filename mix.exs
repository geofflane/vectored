defmodule Vectored.MixProject do
  use Mix.Project

  def project do
    [
      app: :vectored,
      version: "0.3.1",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:xmerl]
      ],
      # Docs
      name: "Vectored",
      source_url: "https://github.com/geofflane/vectored.git",
      homepage_url: "https://github.com/geofflane/vectored.git",
      docs: [
        # The main page in the docs
        main: "Vectored",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :xmerl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end
end
