defmodule Chronos do

  def today do
    :erlang.date
  end

  def year(date) do
    { year, _, _ } = date
    year
  end

  def month(date) do
    { _, month, _ } = date
    month
  end

  def day(date) do
    { _, _, day } = date
    day
  end

end
