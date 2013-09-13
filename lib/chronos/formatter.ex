defmodule Chronos.Formatter do

  def strftime({ y, _, _ }, f) when f =="%Y", do: to_binary(y)
  def strftime({ y, _, _ }, f) when f =="%y", do: rem(y, 100) |> to_binary

  def strftime({ _, m, _ }, f) when f =="%m", do: to_binary(m)
  def strftime({ _, _, d }, f) when f =="%d", do: to_binary(d)

end
