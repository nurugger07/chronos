defmodule Chronos do

  alias :calendar, as: Cal
  alias :erlang, as: Erl

  @default_format "~4..0B-~1..0B-~2..0B"

  def today do
    Erl.date
  end

  def now do
    Erl.now |> Cal.now_to_datetime
  end

  def year(date) do
    { year, _, _ } = validate(date)
    year
  end

  def month(date) do
    { _, month, _ } = validate(date)
    month
  end

  def day(date) do
    { _, _, day } = validate(date)
    day
  end

  def valid_date?(date), do: Cal.valid_date(date)

  defp validate(date) do
    cond do
      valid_date?(date) -> date
      :else ->
        raise ArgumentError, message: "Invalid date argument #{inspect date}"
    end
  end

  defp date_to_list(date) when is_tuple(date), do: tuple_to_list(date)
end
