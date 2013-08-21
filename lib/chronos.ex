defmodule Chronos do

  import Chronos.Validation

  def today, do: :erlang.date

  def now do
    :erlang.now |> :calendar.now_to_datetime
  end

  def year(date) do
    validate(date) |> _extract_seg(:year)
  end

  def month(date) do
    validate(date) |> _extract_seg(:month)
  end

  def day(date) do
    validate(date) |> _extract_seg(:day)
  end

  def yesterday(date // :erlang.date) do
    date |> days_for_date |> date_for_days(-1)
  end

  defp days_for_date(date), do: :calendar.date_to_gregorian_days(date)

  defp date_for_days(days, offset // 0) when is_integer(days) do
    :calendar.gregorian_days_to_date(days + offset)
  end

  defp _extract_seg({ year, _, _ }, :year), do: year
  defp _extract_seg({ _, month, _ }, :month), do: month
  defp _extract_seg({ _, _, day }, :day), do: day

  defp _opts_date({ :ok, date }), do: date

  defmacro __using__(opts // []) do
    date = cond do
      opts[:date] ->
        Keyword.values(opts) |> Enum.fetch(0) |> _opts_date
      :else ->
        :erlang.date
    end

    quote do
      def today, do: unquote(date)

      def now, do: unquote(__MODULE__).now

      def year(date), do: unquote(__MODULE__).year(date)

      def month(date), do: unquote(__MODULE__).month(date)

      def day(date), do: unquote(__MODULE__).day(date)

      def yesterday(date // unquote(date)) do
        unquote(__MODULE__).yesterday(date)
      end
    end
  end

end
