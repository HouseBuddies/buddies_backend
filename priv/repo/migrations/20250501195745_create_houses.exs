defmodule BuddiesBackend.Repo.Migrations.CreateHouses do
  use Ecto.Migration

  def change do
    create table(:houses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :rent, :decimal
      add :rooms, :integer
      add :available_date, :utc_datetime
      add :max_residents, :integer, default: 5
      add :address, :string
      add :tags, {:array, :string}, default: []
      add :likes, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end
  end
end
