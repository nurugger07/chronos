defmodule Chronos do

  import Chronos.Validation

  @doc """
    Chronos is an Elixir library for working with dates and times.

    iex(1)> Chronos.today
    {2013, 8, 21}

  """
  def today, do: :erlang.date

  def now, do: :erlang.now |> :calendar.now_to_datetime

  @doc """
    Return a date/time tuple by parsing from a string according to some
    [RFC 2616](http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1)
    format.
  """
  def httpdate(date) when is_binary(date) do
    weekday = "(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)"
    wkday = "(Mon|Tue|Wed|Thu|Fri|Sat|Sun)"
    month = "(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)"
    date1 = "(?<day>\\d{2}) (?<month>#{month}) (?<year>\\d{4})"
    date2 = "(?<day>\\d{2})-(?<month>#{month})-(?<year>\\d{2})"
    date3 = "(?<month>#{month}) (?<day>(\\d{2}| \\d))"
    time = "(?<hour>\\d{2}):(?<min>\\d{2}):(?<sec>\\d{2})"
    rfc1123 = ~r/#{wkday}, #{date1} #{time} GMT/g
    rfc850 = ~r/#{weekday}, #{date2} #{time} GMT/g
    asctime = ~r/#{wkday} #{date3} #{time} (?<year>\d{4})/g
    cond do
      String.match?(date, rfc1123) ->
        date = Regex.named_captures(rfc1123, date)
        {
          {
            binary_to_integer(date[:year]),
            month_name_to_number(date[:month]),
            binary_to_integer(date[:day])
          }, {
            binary_to_integer(date[:hour]),
            binary_to_integer(date[:min]),
            binary_to_integer(date[:sec])
          }
        }
      String.match?(date, rfc850) ->
        date = Regex.named_captures(rfc850, date)
        {
          {
            two_digit_year_to_full(binary_to_integer(date[:year])),
            month_name_to_number(date[:month]),
            binary_to_integer(date[:day])
          }, {
            binary_to_integer(date[:hour]),
            binary_to_integer(date[:min]),
            binary_to_integer(date[:sec])
          }
        }
      String.match?(date, asctime) ->
        date = Regex.named_captures(asctime, date)
        {
          {
            binary_to_integer(date[:year]),
            month_name_to_number(date[:month]),
            binary_to_integer(String.strip(date[:day]))
          }, {
            binary_to_integer(date[:hour]),
            binary_to_integer(date[:min]),
            binary_to_integer(date[:sec])
          }
        }
      true ->
        raise ArgumentError, message: "String did not match RFC 2616"
    end
  end

  defp two_digit_year_to_full(year) when year > 68 do
    binary_to_integer("19#{year}")
  end
  defp two_digit_year_to_full(year) do
    binary_to_integer("20#{year}")
  end
  defp month_name_to_number("Jan"), do: 1
  defp month_name_to_number("Feb"), do: 2
  defp month_name_to_number("Mar"), do: 3
  defp month_name_to_number("Apr"), do: 4
  defp month_name_to_number("May"), do: 5
  defp month_name_to_number("Jun"), do: 6
  defp month_name_to_number("Jul"), do: 7
  defp month_name_to_number("Aug"), do: 8
  defp month_name_to_number("Sep"), do: 9
  defp month_name_to_number("Oct"), do: 10
  defp month_name_to_number("Nov"), do: 11
  defp month_name_to_number("Dec"), do: 12

  @doc """
    The year function allows you to extract the year from a date tuple

    iex(1)> Chronos.year({2013, 8, 21})
    2013

    iex(2)> {2012, 12, 21} |> Chronos.year
    2012
  """
  def year(date \\ today), do: validate(date) |> _extract_seg(:year)

  @doc """
    The month function allows you to extract the month from a date tuple

    iex(1)> Chronos.month({2013, 8, 21})
    8

    iex(2)> {2012, 12, 21} |> Chronos.month
    8
  """
  def month(date \\ today), do: validate(date) |> _extract_seg(:month)

  @doc """
    The day function allows you to extract the day from a date tuple

    iex(1)> Chronos.day({2013, 8, 21})
    21

    iex(2)> {2012, 12, 21} |> Chronos.day
    21
  """
  def day(date \\ today), do: validate(date) |> _extract_seg(:day)

  @doc """
    The yday function allows you to extract the day of the year (1-366) from a
    date tuple

    iex(1)> Chronos.yday({2013, 8, 21})
    233

    iex(2)> {2012, 12, 21} |> Chronos.day
    356
  """
  def yday(date \\ today) do
    yd = validate(date)
    |> _extract_seg(:year)
    |> :calendar.date_to_gregorian_days(1,1)
    :calendar.date_to_gregorian_days(date) - yd + 1
  end

  @doc """
    The yesterday function is based on the current date

    iex(1)> Chronos.yesterday
    {2013, 8, 20}

    or you can pass it a date:

    iex(2)> {2012, 12, 21} |> Chronos.yesterday
    {2012, 12, 20}

  """
  def yesterday(date \\ :erlang.date), do: calculate_date_for_days(date, -1)

  @doc """
    The tomorrow function is based on the current date

    iex(1)> Chronos.tomorrow
    {2013, 8, 22}

    or you can pass it a date:

    iex(2)> {2012, 12, 21} |> Chronos.tomorrow
    {2012, 12, 22}

  """
  def tomorrow(date \\ :erlang.date), do: calculate_date_for_days(date, 1)

  @doc """
    The following functions all have similar behavior. The days_ago/2 and weeks_ago/2
    functions take a integer representing the number of days or weeks in the past and
    return the corresponding date. There is a optional argument for a date to base the
    calculation on but if no date is provided then the current date is used.

    iex(1)> Chronos.days_ago(5)
    {2013, 8, 16}

    iex(2)> Chronos.weeks_ago(3)
    {2013, 3, 31}

    The days_from/2 and weeks_from/2 return a future date calculated by the number
    of days or weeks. There is a optional argument for a date to base the
    calculation on but if no date is provided then the current date is used.

    iex(1)> Chronos.days_from(5)
    {2013, 8, 26}

    iex(2)> Chronos.weeks_from(3)
    {2013, 9, 11}
  """
  def days_ago(days, date \\ :erlang.date) when days > 0 do
    calculate_date_for_days(date, -days)
  end
  def days_ago(_, _) do
    raise ArgumentError, message: "Number of days must be a positive integer"
  end

  def days_from(days, date \\ :erlang.date) when days > 0 do
    calculate_date_for_days(date, days)
  end
  def days_from(_, _) do
    raise ArgumentError, message: "Number of days must be a positive integer"
  end

  def weeks_ago(weeks, date \\ :erlang.date) when weeks > 0 do
    calculate_date_for_weeks(date, -weeks)
  end
  def weeks_ago(_, _) do
    raise ArgumentError, message: "Number of weeks must be a positive integer"
  end

  def weeks_from(weeks, date \\ :erlang.date) when weeks > 0 do
    calculate_date_for_weeks(date, weeks)
  end
  def weeks_from(_, _) do
    raise ArgumentError, message: "Number of weeks must be a positive integer"
  end

  defp calculate_date_for_days(date, days) do
   covert_date_to_days(date) |> date_for_days(days)
  end

  defp calculate_date_for_weeks(date, weeks) do
   covert_date_to_days(date) |> date_for_weeks(weeks)
  end

  defp covert_date_to_days(date), do: validate(date) |> days_for_date

  defp days_for_date(date), do: :calendar.date_to_gregorian_days(date)

  defp date_for_days(days, offset) when is_integer(days) do
    :calendar.gregorian_days_to_date(days + offset)
  end
  defp date_for_weeks(days, weeks) when is_integer(days) do
    date_for_days(days, weeks * 7)
  end

  defp _extract_seg({ year, _, _ }, :year), do: year
  defp _extract_seg({ _, month, _ }, :month), do: month
  defp _extract_seg({ _, _, day }, :day), do: day

  defp _opts_date({ :ok, date }), do: date

  @doc """
    There is an option to supply a date. This is handy for testing.

    defmodule YourModule do
      use Chronos, date: {2012, 12, 21}
    end

    iex(1)> YourModule.today
    {2012, 12, 21}
  """
  defmacro __using__(opts \\ []) do
    date = fn() -> cond do
        opts[:date] ->
          Keyword.values(opts) |> Enum.fetch(0) |> _opts_date
        :else ->
          :erlang.date
      end
    end

    quote do
      def today, do: unquote(date.())

      def now, do: unquote(__MODULE__).now

      def year(date), do: unquote(__MODULE__).year(date)

      def month(date), do: unquote(__MODULE__).month(date)

      def day(date), do: unquote(__MODULE__).day(date)

      def yday(date), do: unquote(__MODULE__).yday(date)

      def yesterday(date \\ unquote(date.())) do
        unquote(__MODULE__).yesterday(date)
      end

      def tomorrow(date \\ unquote(date.())) do
        unquote(__MODULE__).tomorrow(date)
      end

      def days_ago(days, date \\ unquote(date.())) do
        unquote(__MODULE__).days_ago(days, date)
      end

      def days_from(days, date \\ unquote(date.())) do
        unquote(__MODULE__).days_from(days, date)
      end

      def weeks_ago(weeks, date \\ unquote(date.())) do
        unquote(__MODULE__).weeks_ago(weeks, date)
      end

      def weeks_from(weeks, date \\ unquote(date.())) do
        unquote(__MODULE__).weeks_from(weeks, date)
      end
    end
  end

end
