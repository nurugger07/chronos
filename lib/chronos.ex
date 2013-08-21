defmodule Chronos do

  import Chronos.Validation

  def today, do: :erlang.date

  def now do
    :erlang.now |> :calendar.now_to_datetime
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
    end
  end

end
