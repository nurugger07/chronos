defmodule ChronosTest do
  use ExUnit.Case

  import Chronos

  @today :erlang.date

  test :today do
    assert today == @today
  end

  test :now do
    assert now == :calendar.now_to_datetime(:erlang.now)
  end

  test :valid_date? do
    assert valid_date?({ 2012, 12, 21 })
    assert valid_date?({ 2008, 2, 29 })
    refute valid_date?({ 2009, 2, 29 })
    refute valid_date?({ 0000, -2, 29 })
  end

  test "today's year" do
    { year, _, _ } = @today
    assert today |> year  == year

    assert_raise ArgumentError, "Invalid date argument {2013, 13, 41}", fn ->
      year({2013, 13, 41})
    end
  end

  test "today's month" do
    { _, month, _ } = @today
    assert today |> month == month

    assert_raise ArgumentError, "Invalid date argument {2013, 13, 41}", fn ->
      month({2013, 13, 41})
    end
  end

  test "today's day" do
    { _, _, day } = @today
    assert today |> day == day

    assert_raise ArgumentError, "Invalid date argument {2013, 13, 41}", fn ->
      day({2013, 13, 41})
    end
  end

end
