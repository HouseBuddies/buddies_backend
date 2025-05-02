defmodule BuddiesBackend.Managements.Management do
  use BuddiesBackend.Schema

  alias BuddiesBackend.Managements.{BillSpliter, Calendar, ShoppingCart, TodoList}
  alias BuddiesBackend.Houses.House

  @required_fields ~w(house_id)a

  schema "managements" do
    belongs_to :house, House
    has_one :bill_spliter, BillSpliter
    has_one :calendar, Calendar
    has_one :shopping_cart, ShoppingCart
    has_one :todo_list, TodoList

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(management, attrs) do
    management
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:house)
  end
end
