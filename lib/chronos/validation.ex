defmodule Chronos.Validation do

  alias :calendar, as: Cal

  def valid_date?(date), do: Cal.valid_date(date)

  def validate(date) do
    cond do
      valid_date?(date) -> date
      :else ->
        raise ArgumentError, message: "Invalid date argument #{inspect date}"
    end
  end

end
