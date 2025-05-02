defmodule BuddiesBackend.Managements.TodoList do
  use BuddiesBackend.Schema

  alias BuddiesBackend.Tasks.Task

  @required_fields ~w(management_id)a
  @optional_fields ~w()a

  schema "todolists" do
    has_many :tasks, Task
    belongs_to :management, BuddiesBackend.Managements.Management
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo_list, attrs) do
    todo_list
    |> cast(attrs, @required_fields)
    |> validate_required([:management_id])
  end
end
