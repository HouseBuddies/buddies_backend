defmodule BuddiesBackend.Houses.House do
  use BuddiesBackend.Schema
  alias BuddiesBackend.Accounts.User
  alias BuddiesBackend.Subscriptions.Subscription

  @required_fields ~w(rent rooms available_date address max_residents)a
  @optional_fields ~w(tags likes subscription_id)a

  schema "houses" do
    has_many :residents, User
    field :address, :string
    field :rent, :decimal
    field :rooms, :integer
    field :available_date, :utc_datetime
    field :max_residents, :integer, default: 5
    field :tags, {:array, :string}, default: []
    field :likes, {:array, :string}, default: []
    belongs_to :subscription, Subscription

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(house, attrs) do
    house
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:rent, greater_than: 0)
    |> validate_number(:rooms, greater_than: 0)
    |> validate_number(:max_residents, greater_than: 0)
    |> validate_length(:address, min: 5)
  end
end
