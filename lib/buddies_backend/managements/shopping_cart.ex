defmodule BuddiesBackend.Managements.ShoppingCart do
  use BuddiesBackend.Schema
  alias BuddiesBackend.Products.Product

  schema "shoppingcarts" do
    has_many :products, Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shopping_cart, attrs) do
    shopping_cart
    |> cast(attrs, [])
    |> validate_required([])
  end
end
