defmodule BuddiesBackend.BillSplitersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.BillSpliters` context.
  """

  @doc """
  Generate a bill_spliter.
  """
  def bill_spliter_fixture(attrs \\ %{}) do
    {:ok, bill_spliter} =
      attrs
      |> Enum.into(%{})
      |> BuddiesBackend.BillSpliters.create_bill_spliter()

    bill_spliter
  end
end
