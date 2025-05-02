defmodule BuddiesBackend.CalendarsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.Calendars` context.
  """

  @doc """
  Generate a calendar.
  """
  def calendar_fixture(attrs \\ %{}) do
    {:ok, calendar} =
      attrs
      |> Enum.into(%{

      })
      |> BuddiesBackend.Calendars.create_calendar()

    calendar
  end
end
