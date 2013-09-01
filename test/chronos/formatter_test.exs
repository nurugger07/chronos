defmodule FormatterTest do
  use ExUnit.Case

  import Chronos.Formatter

  @today :erlang.date
  @now :erlang.time

  test :short_date_string do
    { year, month, day } = @today
    assert @today |> to_short_date_string == "#{year}-#{two_digits month}-#{two_digits day}"
  end

  test :short_time_string do
    { hour, minute, second } = @now
    assert @now |> to_short_time_string == "#{two_digits hour}:#{two_digits minute}:#{two_digits second}"
  end

  test :strftime_without_percent_symbol do
    str = "1234abc"
    assert str |> strftime == str
  end

  test :strftime_using_hours_minutes_and_seconds do
    {hour, minute, second}= @now
    str = "%H:%M:%s"
    assert strftime(str) == "#{two_digits hour}:#{two_digits minute}:#{two_digits second}"
  end

  test :strftime_using_days_months_and_days do
    {year, month, day}= @today
    str = "%y-%m-%d"
    assert strftime(str) == "#{year}-#{two_digits month}-#{two_digits day}"
  end

end
