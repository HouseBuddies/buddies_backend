defmodule BuddiesBackend.Managements.ShoppingCart do
  use BuddiesBackend.Schema
  alias BuddiesBackend.Products.Product

  @required_fields ~w(management_id)a
  @optional_fields ~w()a

  schema "shoppingcarts" do
    has_many :products, Product
    belongs_to :management, BuddiesBackend.Managements.Management
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shopping_cart, attrs) do
    shopping_cart
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
