defmodule BuddiesBackend.Tasks.TaskUser do
  use BuddiesBackend.Schema

  alias BuddiesBackend.Tasks.Task
  alias BuddiesBackend.Accounts.User

  @required_fields ~w(task_id user_id)
  @optional_fields ~w()

  schema "users_task" do
    belongs_to :user, User
    belongs_to :task, Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task_user, attrs) do
    task_user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:task_id, :user_id], name: :unique_task_user)
  end
end
