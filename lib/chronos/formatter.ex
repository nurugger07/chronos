defmodule Chronos.Formatter do

  @default_format "~4..0B-~1..0B-~2..0B"

  def to_short_date_string(date) do
    date_to_list(date) |> format_for(@default_format)
  end

  defp date_to_list(date) when is_tuple(date), do: tuple_to_list(date)

  defp format_for(date, format) when is_list(date) do
    :io_lib.format(format, date) |> iolist_to_binary
  end
end
