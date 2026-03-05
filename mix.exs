defmodule Vectored.MixProject do
  use Mix.Project

  @version "0.3.4"
  @source_url "https://github.com/geofflane/vectored"

  def project do
    [
      app: :vectored,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:xmerl]
      ],

      # Hex
      description:
        "A lightweight, extensible Elixir library for generating SVG images programmatically using Erlang's built-in :xmerl.",
      package: package(),

      # Docs
      name: "Vectored",
      source_url: @source_url,
      homepage_url: @source_url,
      docs: docs()
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      },
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE.md)
    ]
  end

  defp docs do
    [
      main: "Vectored",
      extras: ["README.md", "LICENSE.md"],
      source_ref: "v#{@version}",
      source_url: @source_url
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
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true}
    ]
  end
end
