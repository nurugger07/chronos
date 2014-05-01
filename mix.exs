Code.ensure_loaded?(Hex) and Hex.start

defmodule Chronos.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chronos,
      version: "0.3.0",
      elixir: ">= 0.13.0",
      deps: [{ :ex_doc, github: "elixir-lang/ex_doc" }],
      package: [
        files: ["lib", "mix.exs", "README*", "LICENSE*"],
        contributors: ["Johnny Winn"],
        licenses: ["Apache 2.0"],
        links: [ github: "https://github.com/nurugger07/chronos" ]
      ],
      description: """
      An Elixir library for handling dates. It can be used to quickly determine a date. In a human readable format.
      """
    ]
  end
end
