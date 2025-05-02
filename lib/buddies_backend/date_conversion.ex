defmodule DateConversion do
  def convert_to_utc(date_string) do
    case parse_date(date_string) do
      {:ok, iso_date} ->
        # Construct the full datetime string with time as 00:00:00
        datetime_string = "#{iso_date} 00:00:00"

        # Create DateTime from NaiveDateTime
        naive_datetime = NaiveDateTime.from_iso8601(datetime_string)

        case naive_datetime do
          {:ok, naive_datetime} ->
            DateTime.from_naive!(naive_datetime, "UTC")

          {:error, _reason} ->
            {:error, "Invalid date format"}
        end

      {:error, _reason} ->
        {:error, "Invalid date format"}
    end
  end

  defp parse_date(date_string) do
    # Split the date string into day, month, and year
    case String.split(date_string, "-") do
      [day, month, year] when is_binary(day) and is_binary(month) and is_binary(year) ->
        # Build the ISO8601 date string (YYYY-MM-DD)
        {:ok, "#{year}-#{month}-#{day}"}

      _ ->
        {:error, "Invalid date format"}
    end
  end
end
