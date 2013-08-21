defmodule HourGlassFixture do
  use Chronos, date: { 2012, 12, 21 }
end

defmodule ChronosTest do
  use ExUnit.Case

  @today { 2012, 12, 21 }

  import HourGlassFixture

  test :today do
    assert today == @today
  end

  test :now do
    assert now == :calendar.now_to_datetime(:erlang.now)
  end

  test "today's year" do
    { year, _, _ } = @today
    assert today |> year  == year
  end

  test "today's month" do
    { _, month, _ } = @today
    assert today |> month == month
  end

  test "today's day" do
    { _, _, day } = @today
    assert today |> day == day
  end

end
