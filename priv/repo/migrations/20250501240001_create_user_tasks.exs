defmodule BuddiesBackend.Repo.Migrations.CreateUserTasks do
  use Ecto.Migration

  def change do
    create table(:user_tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :task_id, references(:tasks, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
