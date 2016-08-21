defmodule Razorpay.Mixfile do
  use Mix.Project

  def project do
    [app: :razorpay,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_cli_env: [
        vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
      ],
     deps: deps()]
  end

  def application do
    [applications: [:logger, :hackney]]
  end
  
  defp deps do
    [{:hackney, "~> 1.6"},
     {:poison, "~> 2.0"},
     {:exvcr, "~> 0.8", only: :test}]
  end
end
