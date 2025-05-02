defmodule BuddiesBackend.Plans.Plan do
  use BuddiesBackend.Schema

  @required_fields ~w(name description price)a
  @optional_fields ~w()a

  schema "plans" do
    field :name, :string
    field :description, :string
    field :price, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:price, greater_than: 0)
    |> validate_length(:name, min: 3)
    |> validate_length(:description, min: 10)
    |> unique_constraint(:name)
  end
end
