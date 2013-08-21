defmodule FormatterTest do
  use ExUnit.Case

  import Chronos.Formatter

  @today :erlang.date

  test :short_date_string do
    { year, month, day } = @today
    assert @today |> to_short_date_string == "#{year}-#{month}-#{day}"
  end
end
