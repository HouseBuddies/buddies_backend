defmodule BuddiesBackendWeb.CalendarJSON do
  alias BuddiesBackend.Managements.Calendar

  @doc """
  Renders a list of calendars.
  """
  def index(%{calendars: calendars}) do
    %{data: for(calendar <- calendars, do: data(calendar))}
  end

  @doc """
  Renders a single calendar.
  """
  def show(%{calendar: calendar}) do
    %{data: data(calendar)}
  end

  defp data(%Calendar{} = calendar) do
    %{
      id: calendar.id
    }
  end
end
