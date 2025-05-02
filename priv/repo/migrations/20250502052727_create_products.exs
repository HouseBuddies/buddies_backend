defmodule BuddiesBackend.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :quantity, :integer
      add :name, :string
      add :state, :string, default: "available"
      add :created_by_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :purchased_by_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
