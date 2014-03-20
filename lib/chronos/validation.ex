defmodule Chronos.Validation do

  alias :calendar, as: Cal

  def valid_date?(date), do: Cal.valid_date(date)

  def validate({date, time}) when is_tuple(date) and is_tuple(time) do
    cond do
      valid_date?(date) and valid_time?(time) -> {date, time}
      :else ->
        raise ArgumentError,
              message: "Invalid date argument #{inspect {date, time}}"
    end
  end

  def validate(date) do
    cond do
      valid_date?(date) -> date
      :else ->
        raise ArgumentError, message: "Invalid date argument #{inspect date}"
    end
  end

  def valid_time?({hour, min, sec})
  when hour < 24 and hour >= 0 and min < 60 and min >=0
  and min < 60 and min >=0 and sec < 60 and sec >=0 do
    true
  end
  def valid_time?(_), do: false

end
