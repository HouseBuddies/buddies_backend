defmodule BuddiesBackend.Repo.Migrations.CreateHouses do
  use Ecto.Migration

  def change do
    create table(:houses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :location, :string
      add :address, :string
      add :owner_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:houses, [:owner_id])
  end
end
