defmodule Chronos do

  import Chronos.Validation

  alias :erlang, as: Erl
  alias :calendar, as: Cal

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

end
