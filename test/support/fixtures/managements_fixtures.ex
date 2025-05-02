defmodule BuddiesBackend.ManagementsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.Managements` context.
  """

  @doc """
  Generate a management.
  """
  def management_fixture(attrs \\ %{}) do
    {:ok, management} =
      attrs
      |> Enum.into(%{

      })
      |> BuddiesBackend.Managements.create_management()

    management
  end
end
