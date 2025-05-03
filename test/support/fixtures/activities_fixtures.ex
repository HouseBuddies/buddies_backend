defmodule BuddiesBackend.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.Activities` context.
  """

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_date: ~U[2025-05-01 23:00:00Z],
        start_date: ~U[2025-05-01 23:00:00Z],
        title: "some title"
      })
      |> BuddiesBackend.Activities.create_activity()

    activity
  end
end
