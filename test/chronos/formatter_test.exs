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
    assert @now |> to_short_time_string == "#{hour}:#{:io_lib.format("~2..0B",[minute])}:#{:io_lib.format("~2..0B",[second])}"
  end
end
