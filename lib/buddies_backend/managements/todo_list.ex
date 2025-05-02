defmodule BuddiesBackend.Managements.TodoList do
  use BuddiesBackend.Schema

  alias BuddiesBackend.Tasks.Task

  schema "todolists" do
    has_many :tasks, Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo_list, attrs) do
    todo_list
    |> cast(attrs, [])
    |> validate_required([])
  end
end
