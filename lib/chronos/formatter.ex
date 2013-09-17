defmodule Chronos.Formatter do

  @doc """

  The Chronos.Formatter module is used to format date tuples

  iex(1)> Chronos.Formatter.strftime({2012, 12, 21}, "%Y-%m-%d")
  "2012-12-21"
  iex(2)> Chronos.Formatter.strftime({2012, 12, 21}, "Presented on %m/%d/%Y")
  "Presented on 12/21/2012"

  """
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
