defmodule BuddiesBackend.Subscriptions.Subscription do
  use BuddiesBackend.Schema
  alias BuddiesBackend.Plans.Plan

  @required_fields ~w(start_date end_date price plan_id)a
  @optional_fields ~w()a

  schema "subscriptions" do
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :price, :decimal
    belongs_to :plan, Plan

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:price, greater_than: 0)
  end
end
