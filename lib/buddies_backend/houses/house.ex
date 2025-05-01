defmodule BuddiesBackend.Houses.House do
  use BuddiesBackend.Schema

  @required_fields ~w(location address owner_id)a

  schema "houses" do
    field :address, :string
    field :location, :string
    belongs_to :owner, BuddiesBackend.Accounts.User, foreign_key: :owner_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(house, attrs) do
    house
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
