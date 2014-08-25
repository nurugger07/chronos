defmodule HourGlassFixture do
  use Chronos, date: { 2012, 12, 21 }
end

defmodule ChronosTest do
  use ExUnit.Case

  @today { 2012, 12, 21 }
  @now {{ 2012, 12, 21 }, {7, 23, 54}}

  import HourGlassFixture

  test :today do
    assert today == @today
  end

  test :now do
    assert :calendar.now_to_datetime(:erlang.now) == now
  end

  test :httpdate do
    assert Chronos.httpdate("Sun, 06 Nov 1994 08:49:37 GMT") == {{1994, 11, 6},
                                                                 {8, 49, 37}}
    assert Chronos.httpdate("Sunday, 06-Nov-94 08:49:37 GMT") == {{1994, 11, 6},
                                                                  {8, 49, 37}}
    assert Chronos.httpdate("Sun Nov  6 08:49:37 1994") == {{1994, 11, 6},
                                                            {8, 49, 37}}
  end

  test :year do
    assert today |> year == _extract_seg(@today, :year)
  end

  test :month do
    assert today |> month == _extract_seg(@today, :month)
  end

  test :day do
    assert today |> day == _extract_seg(@today, :day)
  end

  test :hour do
    assert 7 == @now |> hour
  end

  test :min do
    assert 23 == @now |> min
  end

  test :sec do
    assert 54 == @now |> sec
  end

  test :wday do
    assert {2013, 8, 21} |> wday == 3
    assert {2013, 8, 18} |> sunday? == true
    assert {2013, 8, 19} |> monday? == true
    assert {2013, 8, 20} |> tuesday? == true
    assert {2013, 8, 21} |> wednesday? == true
    assert {2013, 8, 22} |> thursday? == true
    assert {2013, 8, 23} |> friday? == true
    assert {2013, 8, 24} |> saturday? == true
    assert {2013, 8, 24} |> sunday? == false
    assert {2013, 8, 24} |> monday? == false
    assert {2013, 8, 24} |> tuesday? == false
    assert {2013, 8, 24} |> wednesday? == false
    assert {2013, 8, 24} |> thursday? == false
    assert {2013, 8, 24} |> friday? == false
    assert {2013, 8, 25} |> saturday? == false
  end

  test :yday do
    assert {2012, 1, 1} |> yday == 1
    assert {2012, 2, 1} |> yday == 32
  end

  test :yesterday do
    assert today |> yesterday == { 2012, 12, 20 }
    assert yesterday == { 2012, 12, 20 }

    assert { 2013, 1, 1 } |> yesterday == { 2012, 12, 31 }
  end

  test :tomorrow do
    assert today |> tomorrow == { 2012, 12, 22 }
    assert tomorrow == { 2012, 12, 22 }

    assert { 2012, 12, 31 } |> tomorrow == { 2013, 1, 1 }
  end

  test :days_ago do
    assert 10 |> days_ago == { 2012, 12, 11 }
    assert 3 |> days_ago({ 2013, 1, 1 }) == { 2012, 12, 29 }

    assert_raise ArgumentError, "Number of days must be a positive integer", fn ->
      days_ago(-3, @today)
    end
    assert_raise ArgumentError, "Number of days must be a positive integer", fn ->
      days_ago(-2)
    end
  end

  test :days_from do
    assert 10 |> days_from(@today) == { 2012, 12, 31 }
    assert 11 |> days_from(@today) == { 2013, 1, 1 }

    assert_raise ArgumentError, "Number of days must be a positive integer", fn ->
      days_from(-3, @today)
    end
  end

  test :weeks_ago do
    assert 1 |> weeks_ago == { 2012, 12, 14 }
    assert 2 |> weeks_ago == { 2012, 12, 7 }
    assert 1 |> weeks_ago({ 2013, 1, 1 }) == { 2012, 12, 25 }

    assert_raise ArgumentError, "Number of weeks must be a positive integer", fn ->
      weeks_ago(-3, @today)
    end
  end

  test :weeks_from do
    assert 1 |> weeks_from == { 2012, 12, 28 }
    assert 2 |> weeks_from == { 2013, 1, 4 }

    assert_raise ArgumentError, "Number of weeks must be a positive integer", fn ->
      weeks_from(-3, @today)
    end
  end

  defp _extract_seg({ year, _, _ }, :year), do: year
  defp _extract_seg({ _, month, _ }, :month), do: month
  defp _extract_seg({ _, _, day }, :day), do: day

end
