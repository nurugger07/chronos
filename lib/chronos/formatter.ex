defmodule Chronos.Formatter do

  @default_date_format "~4..0B-~2..0B-~2..0B"
  @default_time_format "~2..0B:~2..0B:~2..0B"

  def to_short_date_string(date) do
    to_list(date) |> format_for(@default_date_format)
  end

  def to_short_time_string(time) do
    to_list(time) |> format_for(@default_time_format)
  end

  def strftime(string) do
    {hour, minute, second} = :erlang.time
    {year, month, day} = :erlang.date
    cond do
      Regex.match?(%r"%s", string) ->
        strftime(Regex.replace(%r"%s", string, two_digits(second)))
      Regex.match?(%r"%m", string) ->
        strftime(Regex.replace(%r"%m", string, two_digits(minute)))
      Regex.match?(%r"%h", string) ->
        strftime(Regex.replace(%r"%h", string, two_digits(hour)))
      true ->
        string
    end
  end

  def two_digits(x), do: to_string :io_lib.format("~2..0B",[x])

  defp to_list(date) when is_tuple(date), do: tuple_to_list(date)

  defp format_for(date, format) when is_list(date) do
    :io_lib.format(format, date) |> iolist_to_binary
  end

end
