defmodule BuddiesBackend.Products.Product do
  use BuddiesBackend.Schema
  alias BuddiesBackend.Accounts.User
  alias BuddiesBackend.Managements.ShoppingCart

  @required_fields ~w(name quantity created_by_id state shopping_cart_id)a
  @optional_fields ~w(purchased_by_id)a

  schema "products" do
    field :name, :string
    field :quantity, :integer
    field :state, Ecto.Enum, values: [:available, :purchased], default: :available
    belongs_to :created_by, User
    belongs_to :purchased_by, User
    belongs_to :shopping_cart, ShoppingCart

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
