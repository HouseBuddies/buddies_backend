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
        available_date: ~U[2025-04-30 19:57:00Z],
        rent: "120.5",
        rooms: 42
      })
      |> BuddiesBackend.Houses.create_house()

    house
  end

  @doc """
  Generate a user_house.
  """
  def user_house_fixture(attrs \\ %{}) do
    {:ok, user_house} =
      attrs
      |> Enum.into(%{})
      |> BuddiesBackend.Houses.create_user_house()

    user_house
  end
end
