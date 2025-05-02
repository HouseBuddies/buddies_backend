defmodule BuddiesBackend.Repo.Migrations.CreateUserHouses do
  use Ecto.Migration

  def change do
    create table(:user_houses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :house_id, references(:houses, type: :binary_id, on_delete: :delete_all)
      add :type, :string, values: ["resident", "owner", "favorite", "match"], default: "resident"

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_houses, [:user_id, :house_id, :type], name: :unique_user_house)
  end
end
