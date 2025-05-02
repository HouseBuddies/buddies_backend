defmodule BuddiesBackend.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string
      add :due_date, :utc_datetime
      add :finished, :boolean, default: false, null: false
      add :creator_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :todo_list_id, references(:todolists, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
