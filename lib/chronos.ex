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
    The hour function allows you to extract the hour from a date/time tuple

    iex> Chronos.hour({{2013, 8, 21}, {13, 34, 45}})
    13

    iex> {{2013, 8, 21}, {13, 34, 45}} |> Chronos.hour
    13
  """
  def hour(datetime \\ now), do: validate(datetime) |> _extract_seg(:hour)

  @doc """
    The min function allows you to extract the minutes from a date/time tuple

    iex> Chronos.min({{2013, 8, 21}, {13, 34, 45}})
    34

    iex> {{2013, 8, 21}, {13, 34, 45}} |> Chronos.min
    34
  """
  def min(datetime \\ now), do: validate(datetime) |> _extract_seg(:min)

  @doc """
    The sec function allows you to extract the seconds from a date/time tuple

    iex> Chronos.sec({{2013, 8, 21}, {13, 34, 45}})
    45

    iex> {{2013, 8, 21}, {13, 34, 45}} |> Chronos.sec
    45
  """
  def sec(datetime \\ now), do: validate(datetime) |> _extract_seg(:sec)

  @doc """
    Returns an integer representing the day of the week, 1..7, with Monday == 1.

    iex(1)> Chronos.wday({2013, 8, 21})
    3
  """
  def wday(date \\ today), do: :calendar.day_of_the_week(date)

  def sunday?(date \\ today), do: wday(date) == 7
  def monday?(date \\ today), do: wday(date) == 1
  def tuesday?(date \\ today), do: wday(date) == 2
  def wednesday?(date \\ today), do: wday(date) == 3
  def thursday?(date \\ today), do: wday(date) == 4
  def friday?(date \\ today), do: wday(date) == 5
  def saturday?(date \\ today), do: wday(date) == 6

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
  def yesterday(date \\ today), do: calculate_date_for_days(date, -1)

  @doc """
    The tomorrow function is based on the current date

    iex(1)> Chronos.tomorrow
    {2013, 8, 22}

    or you can pass it a date:

    iex(2)> {2012, 12, 21} |> Chronos.tomorrow
    {2012, 12, 22}
  """
  def tomorrow(date \\ today), do: calculate_date_for_days(date, 1)
  @doc """
    #beginning_of_week/2 function returns the date of starting day of the week for given date.
    It defaults to today for given date and Monday(1) for starting day of the week.
    Mon = 1, Tue = 2, Wed =3 , Thu = 4 , Fri = 5 , Sat = 6 , Sun = 7
    If today is {2012,12,21}
    iex(1)> Chronos.beginning_of_week
    {2012,12,17}
    iex(2)> Chronos.beginning_of_week({2015,1,20})
    {2015,1,19}
    iex(3)> Chronos.beginning_of_week({2015,1,20},3)
    {2015,1,14}
  """
  def beginning_of_week(date \\ today, start_day \\ 1) do
    days = [1,2,3,4,5,6,7]
    offset = start_day- 1
    days = (days |> Enum.reverse |> Enum.take(7-offset) |> Enum.reverse) 
           ++ (days |> Enum.take(offset)) #list rotation hack
    Enum.find_index(days,&(&1 == wday(date))) |> days_ago(date)     
  end

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
  def days_ago(days, date \\ today)
  def days_ago(days, date) when days > 0 do
    calculate_date_for_days(date, -days)
  end
  def days_ago(days, _) when days < 0 do
    raise ArgumentError, message: "Number of days must be a positive integer"
  end

  def days_from(days, date \\ today)
  def days_from(days, date) when days > 0 do
    calculate_date_for_days(date, days)
  end
  def days_from(_, _) do
    raise ArgumentError, message: "Number of days must be a positive integer"
  end

  def weeks_ago(weeks, date \\ today)
  def weeks_ago(weeks, date) when weeks > 0 do
    calculate_date_for_weeks(date, -weeks)
  end
  def weeks_ago(_, _) do
    raise ArgumentError, message: "Number of weeks must be a positive integer"
  end

  def weeks_from(weeks, date \\ today)
  def weeks_from(weeks, date) when weeks > 0 do
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
  defp _extract_seg({ _date, {hour, _, _}}, :hour), do: hour
  defp _extract_seg({ _date, {_, min, _}}, :min), do: min
  defp _extract_seg({ _date, {_, _, sec}}, :sec), do: sec

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

      def hour(datetime), do: unquote(__MODULE__).hour(datetime)

      def min(datetime), do: unquote(__MODULE__).min(datetime)

      def sec(datetime), do: unquote(__MODULE__).sec(datetime)

      def wday(date), do: unquote(__MODULE__).wday(date)

      def sunday?(date), do: unquote(__MODULE__).sunday?(date)
      def monday?(date), do: unquote(__MODULE__).monday?(date)
      def tuesday?(date), do: unquote(__MODULE__).tuesday?(date)
      def wednesday?(date), do: unquote(__MODULE__).wednesday?(date)
      def thursday?(date), do: unquote(__MODULE__).thursday?(date)
      def friday?(date), do: unquote(__MODULE__).friday?(date)
      def saturday?(date), do: unquote(__MODULE__).saturday?(date)

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

      def beginning_of_week(date \\ unquote(date.()),start_day \\ 1) do
        unquote(__MODULE__).beginning_of_week(date, start_day)
      end
    end
  end

end
