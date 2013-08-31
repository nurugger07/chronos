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

  test :strftime_using_hours do
    {hour, _, _}= @now
    str = "%h"
    assert str |> strftime == two_digits hour
  end

end
