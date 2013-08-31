defmodule FormatterTest do
  use ExUnit.Case

  import Chronos.Formatter

  @today :erlang.date
  @now :erlang.time

  test :short_date_string do
    { year, month, day } = @today
    assert @today |> to_short_date_string == "#{year}-#{:io_lib.format("~2..0B",[month])}-#{:io_lib.format("~2..0B",[day])}"
  end

  test :short_time_string do
    { hour, minute, second } = @now
    assert @now |> to_short_time_string == "#{:io_lib.format("~2..0B",[hour])}:#{:io_lib.format("~2..0B",[minute])}:#{:io_lib.format("~2..0B",[second])}"
  end

  test :strftime_without_percent_symbol do

  end

  test :strftime_using_hours do
    {hour, _, _}= @now
    str = "%h"
    assert strftime(str) == to_string :io_lib.format("~2..0B",[hour])
  end

end
