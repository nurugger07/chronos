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
    assert today |> year  == _extract_seg(@today, :year)
  end

  test "today's month" do
    assert today |> month == _extract_seg(@today, :month)
  end

  test "today's day" do
    assert today |> day == _extract_seg(@today, :day)
  end

  defp _extract_seg({ year, _, _ }, :year), do: year
  defp _extract_seg({ _, month, _ }, :month), do: month
  defp _extract_seg({ _, _, day }, :day), do: day

end
