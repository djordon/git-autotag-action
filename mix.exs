defmodule Devoro.Mixfile do
  use Mix.Project

  def project do
    [
      app: :devoro,
      version: "0.1.0",
      elixir: "~> 1.8.1",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end
end
