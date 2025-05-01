defmodule BuddiesBackend.PlansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.Plans` context.
  """

  @doc """
  Generate a plan.
  """
  def plan_fixture(attrs \\ %{}) do
    {:ok, plan} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: "120.5"
      })
      |> BuddiesBackend.Plans.create_plan()

    plan
  end
end
