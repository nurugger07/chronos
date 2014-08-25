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

  @daynames [nil, "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  @abbr_daynames [nil, "Mon", "Tue", "Wed", "Thru", "Fri", "Sat", "Sun"]

  @flags String.to_char_list "0_^"
  @conversions String.to_char_list "AaDYyCmBbdHMSPpj"

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
    call_format({ date, time }, f)
  end

  def strftime(date, f) do
    call_format({ date, :erlang.time }, f)
  end

  @doc """

  The `http_date` function applies the default format for RFC 822 on
  a specified date. (RFC 822, updated by RFC 1123)

  ```
  iex> Chronos.Formatter.http_date({{2012, 12, 21}, { 13, 31, 45 }})
  "Fri, 21 Dec 2012 18:31:45 -0000"
  ```

  Additional options include RFC 850 (obsoleted by RFC 1036) and asctime() format

  ```
  iex> Chronos.Formatter.http_date({{2012, 12, 21}, { 13, 31, 45 }}, :rfc850)
  "Friday, 21-Dec-2012 18:31:45 GMT"

  iex> Chronos.Formatter.http_date({{2012, 12, 21}, { 13, 31, 45 }}, :asctime)
  "Fri Dec 21 18:31:45 2012"
  ```

  """
  def http_date(date_time) do
    date_time |> universal_datetime |> strftime("%a, %d %b %Y %H:%M:%S GMT")
  end

  def http_date(date_time, :rfc850) do
    date_time |> universal_datetime |> strftime("%A, %d-%b-%Y %H:%M:%S GMT")
  end

  def http_date(date_time, :asctime) do
    date_time |> universal_datetime |> strftime("%a %b %d %H:%M:%S %Y")
  end

  defp universal_datetime(date_time) do
    :calendar.local_time_to_universal_time_dst(date_time) |> Enum.at(0)
  end

  defp call_format(date, f) do
    format_chars(date, nil, String.to_char_list(f), "", "")
  end

  defp format_chars(_, _, [], token, acc), do: acc <> token

  defp format_chars(date, nil, [h|t], _token, acc) when h == ?% do
    format_chars(date, :flag_or_conversion, t, "%", acc)
  end
  defp format_chars(date, nil, [h|t], _token, acc) do
    format_chars(date, nil, t, "", acc <> <<h>>)
  end

  defp format_chars(date, :flag_or_conversion, [h|t], token, acc) when h in @flags do
    format_chars(date, :conversion, t, token <> <<h>>, acc)
  end
  defp format_chars(date, :flag_or_conversion, [h|t], token, acc) when h in @conversions do
    format_chars(date, nil, t, "", acc <> apply_format(date, token <> <<h>>))
  end
  defp format_chars(date, :flag_or_conversion, [h|t], token, acc) do
    format_chars(date, nil, [h|t], token, acc <> "%")
  end

  defp format_chars(date, :conversion, [h|t], token, acc) when h in @conversions do
    format_chars(date, nil, t, "", acc <> apply_format(date, token <> <<h>>))
  end
  defp format_chars(date, :conversion, [h|t], token, acc) do
    format_chars(date, nil, [h|t], "", acc <> token)
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

  defp apply_format({date, _time}, "%a") do
    @abbr_daynames |> Enum.at(:calendar.day_of_the_week(date))
  end

  defp apply_format(date, "%^a") do
    apply_format(date, "%a") |> String.upcase
  end

  defp apply_format({date, _time}, "%A") do
    @daynames |> Enum.at(:calendar.day_of_the_week(date))
  end

  defp apply_format(date, "%^A") do
    apply_format(date, "%A") |> String.upcase
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
