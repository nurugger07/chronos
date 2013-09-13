defmodule FormatterTest do
  use ExUnit.Case

  @today { 2012, 12, 21 }

  import Chronos.Formatter

  test :strftime_dates do
    # Year
    assert strftime(@today, "%Y") == "2012"
    assert strftime(@today, "%y") == "12"

    # Month
    assert strftime(@today, "%m") == "12"

    # Day
    assert strftime(@today, "%d") == "21"
  end

end
