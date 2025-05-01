defmodule BuddiesBackend.HousesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.Houses` context.
  """

  @doc """
  Generate a house.
  """
  def house_fixture(attrs \\ %{}) do
    {:ok, house} =
      attrs
      |> Enum.into(%{
        address: "some address",
        location: "some location"
      })
      |> BuddiesBackend.Houses.create_house()

    house
  end
end
