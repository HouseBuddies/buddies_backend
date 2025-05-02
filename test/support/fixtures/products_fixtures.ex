defmodule BuddiesBackend.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name",
        quantity: 42
      })
      |> BuddiesBackend.Products.create_product()

    product
  end
end
