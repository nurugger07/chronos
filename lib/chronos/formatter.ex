defmodule Chronos.Formatter do
  @moduledoc """
    The Chronos.Formatter module is used to format date/time tuples.
  """

  @short_date "%Y-%m-%d"

  @monthnames [nil, "January", "February", "March", "April", "May", "June",
                    "July", "August", "September", "October", "November",
                    "December"]

  @abbr_monthnames [nil, "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
                         "Sep", "Oct", "Nov", "Dec"]

  @doc """
  The `strftime` formats date/time according to the directives in the given
  format string.

  Format is a string with directives, where directives is a:

  `%<flags><conversion>`

  Flags:

  * _  use spaces for padding.
  * 0  use zeros for padding.
  * ^  upcase the result string.

  Conversions:

  * Date

  * * %Y - Year with century

    ```
    iex> Chronos.Formatter.strftime({2012, 12, 21}, "%Y")
    "2012"
    ```

  * * %C - Century

    ```
    iex> Chronos.Formatter.strftime({2012, 12, 21}, "%C")
    "20"
    ```

  * * %y - Year without century

    ```
    iex> Chronos.Formatter.strftime({2012, 12, 21}, "%y")
    "12"
    ```

  * * %m - Month of the year

    ```
    iex> Chronos.Formatter.strftime({2012, 12, 21}, "%m")
    "12"

    iex> Chronos.Formatter.strftime({2012, 1, 21}, "%0m")
    "01"

    iex> Chronos.Formatter.strftime({2012, 1, 21}, "%_m")
    " 1"
    ```

  * * %B - The full month name

    ```
    iex> Chronos.Formatter.strftime({2012, 12, 21}, "%B")
    "December"

    iex> Chronos.Formatter.strftime({2012, 1, 21}, "%^B")
    "JANUARY"
    ```

  * * %b - The abbreviated month name

    ```
    iex> Chronos.Formatter.strftime({2012, 12, 21}, "%b")
    "Dec"

    iex> Chronos.Formatter.strftime({2012, 1, 21}, "%^b")
    "JAN"
    ```

  * * %d - Day of the month

    ```
    iex> Chronos.Formatter.strftime({2012, 12, 1}, "%d")
    "1"

    iex> Chronos.Formatter.strftime({2012, 1, 1}, "%_d")
    " 1"

    iex> Chronos.Formatter.strftime({2012, 1, 1}, "%0d")
    "01"
    ```

  * * %j - Day of the year (001..366)

    ```
    iex> Chronos.Formatter.strftime({2012, 2, 1}, "%j")
    "32"

    iex> Chronos.Formatter.strftime({2012, 1, 1}, "%j")
    "1"
    ```

  Examples:

  ```
  iex> Chronos.Formatter.strftime({2012, 12, 21}, "%Y-%m-%d")
  "2012-12-21"

  iex> Chronos.Formatter.strftime({2012, 12, 21}, "Presented on %m/%d/%Y")
  "Presented on 12/21/2012"
  ```
  """
  def strftime({ date, time }, f)  do
    call_format({ date, time }, f) |> Enum.join
  end

  def strftime(date, f) do
    call_format({ date, :erlang.time }, f) |> Enum.join
  end

  defp call_format(date, f) do
    pattern = ~r{(%[0_^]?[DYyCmBbdHMSPpj])}
    format(String.split(f, pattern), date)
  end

  @doc """

  The `to_short_date` function applies the default short date format to
  a specified date

  ```
  iex> Chronos.Formatter.to_short_date({2012, 12, 21})
  "2012-12-21"
  ```
  """
  def to_short_date(date), do: strftime(date, @short_date)

  defp format([], _), do: []
  defp format([h|t], date), do: [apply_format(date, h)] ++ format(t, date)

  defp apply_format({{ y, m, d }, _time}, "%D") do
    strftime({ y, m, d }, "%m/%d/%Y")
  end

  defp apply_format({{ y, _, _ }, _time}, "%Y"), do: "#{y}"
  defp apply_format({{ y, _, _ }, _time}, "%C"), do: "#{div(y, 100)}"
  defp apply_format({{ y, _, _ }, _time}, "%y"), do: "#{rem(y, 100)}"

  defp apply_format({{ _, m, _ }, _time}, "%m"), do: "#{m}"
  defp apply_format({{ _, m, _ }, _time}, "%_m") when m < 10, do: " #{m}"
  defp apply_format({{ _, m, _ }, _time}, "%_m"), do: "#{m}"
  defp apply_format({{ _, m, _ }, _time}, "%0m") when m < 10, do: "0#{m}"
  defp apply_format({{ _, m, _ }, _time}, "%0m"), do: "#{m}"
  defp apply_format({{ _, m, _ }, _time}, "%B"), do: @monthnames |> Enum.at(m)

  defp apply_format({{ _, m, _ }, _time}, "%^B") do
    @monthnames |> Enum.at(m) |> String.upcase
  end

  defp apply_format({{ _, m, _ }, _time}, "%b") do
    @abbr_monthnames |> Enum.at(m)
  end

  defp apply_format({{ _, m, _ }, _time}, "%^b") do
    @abbr_monthnames |> Enum.at(m) |> String.upcase
  end

  defp apply_format({{ _, _, d }, _time}, "%0d") when d < 10, do: "0#{d}"
  defp apply_format({{ _, _, d }, _time}, "%0d"), do: "#{d}"
  defp apply_format({{ _, _, d }, _time}, "%_d") when d < 10, do: " #{d}"
  defp apply_format({{ _, _, d }, _time}, "%_d"), do: "#{d}"
  defp apply_format({{ _, _, d }, _time}, "%d"), do: "#{d}"

  defp apply_format({date, _time}, "%j"), do: "#{Chronos.yday(date)}"

  defp apply_format({ _date, { h, _, _ }}, "%H") when h < 10, do: "0#{h}"
  defp apply_format({ _date, { h, _, _ }}, "%H"), do: "#{h}"
  defp apply_format({ _date, { _, m, _ }}, "%M") when m < 10, do: "0#{m}"
  defp apply_format({ _date, { _, m, _ }}, "%M"), do: "#{m}"
  defp apply_format({ _date, { _, _, s }}, "%S") when s < 10, do: "0#{s}"
  defp apply_format({ _date, { _, _, s }}, "%S"), do: "#{s}"

  defp apply_format({ _date, { h, _, _ }}, "%P") when h < 12, do: "AM"
  defp apply_format({ _date, { h, _, _ }}, "%p") when h < 12, do: "am"
  defp apply_format({ _date, { h, _, _ }}, "%P") when h >= 12, do: "PM"
  defp apply_format({ _date, { h, _, _ }}, "%p") when h >= 12, do: "pm"

  defp apply_format(_, f), do: f
end
