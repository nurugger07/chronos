defmodule ChronosTest do
  use ExUnit.Case

  import Chronos

  @today :erlang.date

  test :today do
    assert today == @today
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
