defmodule BuddiesBackend.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start_date, :utc_datetime, null: false
      add :end_date, :utc_datetime, null: false
      add :title, :string, null: false
      add :description, :string
      add :created_by_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :calendar_id, references(:calendars, type: :binary_id, on_delete: :delete_all), null: false


      timestamps(type: :utc_datetime)
    end
  end
end
