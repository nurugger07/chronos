defmodule Chronos.Formatter do

  def strftime(date, f) do
    format(String.split(f, %r{(%.?)}), date) |> Enum.join
  end

  defp format([], _), do: []
  defp format([h|t], date), do: [apply_format(date, h)] ++ format(t, date)

  defp apply_format({y, _, _}, "%Y"), do: to_binary(y)
  defp apply_format({y, _, _}, "%y"), do: rem(y, 100) |> to_binary
  defp apply_format({ _, m, _ }, "%m"), do: to_binary(m)
  defp apply_format({ _, _, d }, "%d"), do: to_binary(d)
  defp apply_format(_, f), do: f

end
