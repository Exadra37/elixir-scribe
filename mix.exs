defmodule ElixirScribe.MixProject do
  use Mix.Project

  # The Elixir version here needs to be equal or greater then the one
  # used by the Phoenix Framework and Phoenix Installer.
  @elixir_requirement "~> 1.14"
  @scm_url "https://github.com/exadra37/elixir-scribe"

  @description """
  Elixir Scribe - A Mix Task to Generate Elixir and Phoenix Projects

  The Elixir Scribe tool aims to help developers to more easily write clean code in a clean software architecture for enhanced developer experience and productivity.
  """

  def project do
    [
      app: :elixir_scribe,
      name: "Elixir Scribe",
      version: "0.1.0",
      elixir: @elixir_requirement,
      start_permanent: Mix.env() == :prod,
      homepage_url: @scm_url,
      source_url: @scm_url,
      description: @description,
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Paulo Renato (Exadra37)"],
      licenses: ["MIT"],
      links: %{"GitHub" => @scm_url},
      files: ~w(lib priv LICENSE.md mix.exs README.md .formatter.exs)
    ]
  end

  defp docs() do
    [
      main: "readme",
      extras: ["README.md"]
      # groups_for_extras: [
      #   Examples: ~r"test/examples"
      # ],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:norm, "~> 0.13"}
    ]
  end
end
