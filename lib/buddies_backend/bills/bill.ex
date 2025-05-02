defmodule BuddiesBackend.Bills.Bill do
  use BuddiesBackend.Schema

  alias BuddiesBackend.Accounts.User

  @required_fields ~w(price due_date description)a

  schema "bills" do
    field :description, :string
    field :price, :decimal
    field :due_date, :utc_datetime
    has_many :assigned_users, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bill, attrs) do
    bill
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
