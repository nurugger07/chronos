Code.ensure_loaded?(Hex) and Hex.start

defmodule Chronos.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chronos,
      version: "1.8.0",
      elixir: ">= 1.0.0",
      deps: deps(),
      package: [
        files: ["lib", "mix.exs", "README*", "LICENSE*"],
        contributors: ["Johnny Winn"],
        licenses: ["Apache 2.0"],
        links: %{ "GitHub" => "https://github.com/nurugger07/chronos" },
        maintainers: ["Johnny Winn"]
      ],
      name: "Chronos",
      source_url: "https://github.com/nurugger07/chronos",
      docs: [main: "Chronos", # The main page in the docs
             extras: ["README.md"]],
      description: """
      An Elixir library for handling dates. It can be used to quickly determine a date. In a human readable format.
      """
    ]
  end

  def deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
