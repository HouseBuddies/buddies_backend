defmodule BuddiesBackend.Houses.UserHouse do
  use BuddiesBackend.Schema
  alias BuddiesBackend.Accounts.User
  alias BuddiesBackend.Houses.House

  @required_fields ~w(user_id house_id type)a
  @optional_fields ~w()a

  schema "user_houses" do
    belongs_to :user, User
    belongs_to :house, House
    field :type, Ecto.Enum, values: [:resident, :owner, :favorite, :match], default: :resident

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_house, attrs) do
    user_house
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:user_id, :house_id], name: :unique_user_house)
  end
end
