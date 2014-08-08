defmodule FormatterTest do
  use ExUnit.Case

  @today { 2012, 12, 21 }
  @new_year { 2012, 1, 1 }
  @now { {2012, 12, 21}, { 13, 31, 45 } }

  import Chronos.Formatter

  test :to_short_date do
    assert to_short_date(@today) == "2012-12-21"
  end

  test :strftime_exceptions do
    assert strftime(@today, "Date\n%D") == "Date\n12/21/2012"
    assert strftime(@today, "Date%%D") == "Date%12/21/2012"
    assert strftime(@today, "Date%n%D") == "Date%n12/21/2012"
    assert strftime(@today, "Date%0n%%D") == "Date%0n%12/21/2012"
  end

  test :strftime_dates do
    # Date
    assert strftime(@today, "%D") == "12/21/2012"

    # Year
    assert strftime(@today, "%Y") == "2012"
    assert strftime(@today, "%C") == "20"
    assert strftime(@today, "%y") == "12"

    # Month
    assert strftime(@today, "%m") == "12"
    assert strftime(@new_year, "%m") == "1"
    assert strftime(@today, "%0m") == "12"
    assert strftime(@new_year, "%0m") == "01"
    assert strftime(@today, "%_m") == "12"
    assert strftime(@new_year, "%_m") == " 1"
    assert strftime(@today, "%B") == "December"
    assert strftime(@today, "%^B") == "DECEMBER"
    assert strftime(@new_year, "%b") == "Jan"
    assert strftime(@new_year, "%^b") == "JAN"

    # Day
    assert strftime(@today, "%d") == "21"
    assert strftime(@new_year, "%0d") == "01"
    assert strftime(@today, "%_d") == "21"
    assert strftime(@new_year, "%_d") == " 1"
    assert strftime(@new_year, "%d") == "1"

    assert strftime(@new_year, "%j") == "1"
    assert strftime(@today, "%j") == "356"

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
    assert strftime({ {2012, 12, 21}, { 1, 31, 45 } }, "%H") == "01"
    assert strftime(@now, "%M") == "31"
    assert strftime(@now, "%S") == "45"

    earlier_still = {{2012, 12, 21}, {1, 2, 3}}
    assert strftime(earlier_still, "%H") == "01"
    assert strftime(earlier_still, "%M") == "02"
    assert strftime(earlier_still, "%S") == "03"

  end

  test :strftime_compact_letters do
    assert strftime(@now, "%Y-%0m-%0dT%H:%M:%S.000Z") == "2012-12-21T13:31:45.000Z"
  end

end
