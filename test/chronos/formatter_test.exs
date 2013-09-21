defmodule FormatterTest do
  use ExUnit.Case

  @today { 2012, 12, 21 }
  @now { {2012, 12, 21}, { 13, 31, 45 } }

  import Chronos.Formatter

  test :to_short_date do
    assert to_short_date(@today) == "2012-12-21"
  end

  test :strftime_dates do
    # Date
    assert strftime(@today, "%D") == "12/21/2012"

    # Year
    assert strftime(@today, "%Y") == "2012"
    assert strftime(@today, "%y") == "12"

    # Month
    assert strftime(@today, "%m") == "12"

    # Day
    assert strftime(@today, "%d") == "21"
    assert strftime({2012, 12, 1}, "%d") == "1"

    assert strftime(@today, "Presented on %m/%d/%Y") == "Presented on 12/21/2012"
    assert strftime(@today, "%Y-%m-%d") == "2012-12-21"
  end

  test :strftime_date_times do
    assert strftime(@now, "%m/%d/%Y %H:%M:%S %P") == "12/21/2012 13:31:45 PM"
    assert strftime(@now, "%m/%d/%Y %H:%M:%S %p") == "12/21/2012 13:31:45 pm"

    earlier = {{2012, 12, 21}, { 11, 31, 45 }}
    assert strftime(earlier, "%m/%d/%Y %H:%M:%S %P") == "12/21/2012 11:31:45 AM"
    assert strftime(earlier, "%m/%d/%Y %H:%M:%S %p") == "12/21/2012 11:31:45 am"

    assert strftime(@now, "%H") == "13"
    assert strftime(@now, "%M") == "31"
    assert strftime(@now, "%S") == "45"
  end

end
