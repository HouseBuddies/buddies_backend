defmodule BuddiesBackend.Tasks.Task do
  use BuddiesBackend.Schema
  alias BuddiesBackend.Tasks.TodoList
  alias BuddiesBackend.Accounts.User

  @required_fields ~w(description title due_date todo_list_id creator_id)a
  @optional_fields ~w(finished)a

  schema "tasks" do
    field :finished, :boolean, default: false
    field :description, :string
    field :title, :string
    field :due_date, :utc_datetime
    belongs_to :todo_list, TodoList
    belongs_to :creator, User
    has_many :assigned, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
