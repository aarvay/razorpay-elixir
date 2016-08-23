defmodule Razorpay.Mixfile do
  use Mix.Project

  def project do
    [app: :razorpay,
     version: "0.5.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_cli_env: [
        vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
     ],
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger, :hackney]]
  end

  defp deps do
    [{:hackney, "~> 1.6"},
     {:poison, "~> 2.0"},
     {:exvcr, "~> 0.8", only: :test},
     {:mock, "~> 0.1.1", only: :test},
     {:ex_doc, "~> 0.12", only: :dev}]
  end

  defp description do
    "Elixir bindings for the Razorpay API."
  end

  defp package do
    [name: :razorpay,
     maintainers: ["Vignesh Rajagopalan"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/aarvay/razorpay-elixir"}]
  end
end
