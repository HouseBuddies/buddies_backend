defmodule BuddiesBackend.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :price, :decimal

      timestamps(type: :utc_datetime)
    end

    create unique_index(:plans, [:name], name: :unique_plan_name)
  end
end
