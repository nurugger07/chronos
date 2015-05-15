defmodule Chronos.Timezones do

  @zones [
    { "A", "Alpha Time Zone", "+1:00" },
    { "ACDT", "Australian Central Daylight Time", "+10:30" },
    { "ACST", "Australian Central Standard Time", "+9:30" },
    { "ACT", "Australian Central Time", "+10:30" },
    { "ACWST", "Australian Central Western Standard Time", "+8:45" },
    { "ADT", "Arabia Daylight Time", "+3:00" },
    { "ADT", "Atlantic Daylight Time", "-3:00" },
    { "AEDT", "Australian Eastern Daylight Time", "+11:00" },
    { "AEST", "Australian Eastern Standard Time", "+10:00" },
    { "AET", "Australian Eastern Time", "+10:00" },
    { "AFT", "Afghanistan Time", "+4:30" },
    { "AKDT", "Alaska Daylight Time", "-8:00" },
    { "AKST", "Alaska Standard Time", "-9:00" },
    { "CST", "Central Standard Time", "-6:00" },
    { "EST", "Eastern Standard Time", "-5:00" },
    { "GMT", "Greenwich Mean Time", "+0:00" },
    { "MST", "Mountain Standard Time", "-7:00" },
    { "PST", "Pacific Standard Time", "-8:00" },
  ]

  @doc """
    Retrieve a timezones offset
  """
  def offset(nil), do: ""
  def offset({_, _, offset}), do: offset
  def offset(zone) when is_binary(zone) do
    @zones |> Enum.find(fn({abbr, name, _}) -> zone == abbr || zone == name end) |> offset
  end

  @doc """
    Retrieve a timezones abbreviation
  """
  def abbreviation(nil), do: ""
  def abbreviation({abbr, _, _}), do: abbr
  def abbreviation(zone) when is_binary(zone) do
    @zones |> Enum.find(fn({_, name, offset}) -> zone == offset || zone == name end) |> abbreviation
  end

  @doc """
    Retrieve a timezones name
  """
  def name(nil), do: ""
  def name({_, name, _}), do: name
  def name(zone) when is_binary(zone) do
    @zones |> Enum.find(fn({abbr, _, offset}) -> zone == offset || zone == abbr end) |> abbreviation
  end

end
