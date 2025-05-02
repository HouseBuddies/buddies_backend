defmodule BuddiesBackend.Products.Product do
  use BuddiesBackend.Schema
  alias BuddiesBackend.Accounts.User

  @required_fields ~w(name quantity created_by_id purchased_by_id state)a

  schema "products" do
    field :name, :string
    field :quantity, :integer
    field :state, Ecto.Enum, values: [:available, :purchased], default: :available
    belongs_to :created_by, User
    belongs_to :purchased_by, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
