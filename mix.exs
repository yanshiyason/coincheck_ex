defmodule CoincheckEx.Mixfile do
  use Mix.Project

  def project do
    [app: :coincheck_ex,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: "Coincheck API Client",
     package: package(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test],
     source_url: "https://github.com/yanshiyason/coincheck_ex"]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:httpoison, :logger, :poison],
      mod: {CoincheckEx, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 3.1"},
      {:earmark, "~> 1.1", only: :dev},
      {:ex_doc, "~> 0.18", only: :dev},
      {:exvcr, "~> 0.9.0", only: [:dev, :test]},
      {:excoveralls, "~> 0.7.4", only: [:dev, :test]},
      {:credo, "~> 0.8.8", only: [:dev, :test]},
    ]
  end

  defp package() do
    [ # These are the default files included in the package
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Yannick Chiasson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/yanshiyason/coincheck_ex"}
    ]
  end
end
