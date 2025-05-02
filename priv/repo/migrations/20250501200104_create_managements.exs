defmodule BuddiesBackend.Repo.Migrations.CreateManagements do
  use Ecto.Migration

  def change do
    create table(:managements, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :house_id, references(:houses, type: :binary_id, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end
  end
end
