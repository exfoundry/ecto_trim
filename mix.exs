defmodule EctoTrim.MixProject do
  use Mix.Project

  @version "1.0.0"
  @source_url "https://github.com/exfoundry/ecto_trim"

  def project do
    [
      app: :ecto_trim,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "EctoTrim",
      source_url: @source_url,
      docs: [
        main: "EctoTrim",
        source_ref: "v#{@version}",
        extras: ["CHANGELOG.md"],
        skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
      ]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ecto, "~> 3.6"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Ecto parameterized type that trims and normalizes whitespace on cast and dump."
  end

  defp package do
    [
      maintainers: ["Elias Forge"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "https://hexdocs.pm/ecto_trim/changelog.html"
      },
      files: ~w(lib mix.exs README.md CHANGELOG.md LICENSE)
    ]
  end
end
