defmodule Chronos.Formatter do

  @default_date_format "~4..0B-~2..0B-~2..0B"
  @default_time_format "~2..0B:~2..0B:~2..0B"

  def to_short_date_string(date) do
    to_list(date) |> format_for(@default_date_format)
  end

  def to_short_time_string(time) do
    to_list(time) |> format_for(@default_time_format)
  end

  defp to_list(date) when is_tuple(date), do: tuple_to_list(date)

  defp format_for(date, format) when is_list(date) do
    :io_lib.format(format, date) |> iolist_to_binary
  end
end
