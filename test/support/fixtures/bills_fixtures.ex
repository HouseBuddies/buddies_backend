defmodule BuddiesBackend.BillsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.Bills` context.
  """

  @doc """
  Generate a bill.
  """
  def bill_fixture(attrs \\ %{}) do
    {:ok, bill} =
      attrs
      |> Enum.into(%{
        due_date: ~U[2025-05-01 00:34:00Z],
        price: "120.5"
      })
      |> BuddiesBackend.Bills.create_bill()

    bill
  end
end
