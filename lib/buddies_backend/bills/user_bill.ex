defmodule BuddiesBackend.Bills.UserBills do
  use BuddiesBackend.Schema

  alias BuddiesBackend.Bills.Bill
  alias BuddiesBackend.Accounts.User

  @required_fields ~w(bill_id user_id)

  schema "users_task" do
    belongs_to :user, User
    belongs_to :bill, Bill

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task_user, attrs) do
    task_user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:bill_id, :user_id], name: :unique_task_user)
  end
end
