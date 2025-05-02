defmodule BuddiesBackend.ShoppingCartsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.ShoppingCarts` context.
  """

  @doc """
  Generate a shopping_cart.
  """
  def shopping_cart_fixture(attrs \\ %{}) do
    {:ok, shopping_cart} =
      attrs
      |> Enum.into(%{

      })
      |> BuddiesBackend.ShoppingCarts.create_shopping_cart()

    shopping_cart
  end
end
