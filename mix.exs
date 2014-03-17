defmodule Chronos.Mixfile do
  use Mix.Project

  def project do
    [ app: :chronos,
      version: "0.2.0",
      deps: [{ :ex_doc, github: "elixir-lang/ex_doc" }] ]
  end
end
