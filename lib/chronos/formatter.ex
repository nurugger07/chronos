defmodule Chronos.Formatter do

  @short_date "%Y-%m-%d"

  @doc """

  The Chronos.Formatter module is used to format date tuples

  iex> Chronos.Formatter.strftime({2012, 12, 21}, "%Y-%m-%d")
  "2012-12-21"

  iex> Chronos.Formatter.strftime({2012, 12, 21}, "Presented on %m/%d/%Y")
  "Presented on 12/21/2012"

  """
  def strftime({ date, time }, f)  do
    call_format({ date, time }, f) |> Enum.join
  end

  def strftime(date, f) do
    call_format({ date, :erlang.time }, f) |> Enum.join
  end

  def call_format(date, f), do: format(String.split(f, ~r{(%.?)}), date)

  @doc """

  The to_short_date function applies the default short date format to
  a specified date

  iex> Chronos.Formatter.to_short_date({2012, 12, 21})
  "2012-12-21"

  """
  def to_short_date(date), do: strftime(date, @short_date)

  defp format([], _), do: []
  defp format([h|t], date), do: [apply_format(date, h)] ++ format(t, date)

  defp apply_format({{ y, m, d }, _time}, "%D") do
    strftime({ y, m, d }, "%m/%d/%Y")
  end

  defp apply_format({{ y, _, _ }, _time}, "%Y"), do: "#{y}"
  defp apply_format({{ y, _, _ }, _time}, "%y"), do: "#{rem(y, 100)}"
  defp apply_format({{ _, m, _ }, _time}, "%m"), do: "#{m}"
  defp apply_format({{ _, _, d }, _time}, "%d"), do: "#{d}"

  defp apply_format({ _date, { h, _, _ }}, "%H"), do: "#{h}"
  defp apply_format({ _date, { _, m, _ }}, "%M"), do: "#{m}"
  defp apply_format({ _date, { _, _, s }}, "%S"), do: "#{s}"

  defp apply_format({ _date, { h, _, _ }}, "%P") when h < 12, do: "AM"
  defp apply_format({ _date, { h, _, _ }}, "%p") when h < 12, do: "am"
  defp apply_format({ _date, { h, _, _ }}, "%P") when h >= 12, do: "PM"
  defp apply_format({ _date, { h, _, _ }}, "%p") when h >= 12, do: "pm"

  defp apply_format(_, f), do: f

end
