defmodule BuddiesBackend.Managements.ShoppingCart do
  use BuddiesBackend.Schema

  schema "shoppingcarts" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shopping_cart, attrs) do
    shopping_cart
    |> cast(attrs, [])
    |> validate_required([])
  end
end
