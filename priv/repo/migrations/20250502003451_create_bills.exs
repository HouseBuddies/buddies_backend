defmodule BuddiesBackend.Repo.Migrations.CreateBills do
  use Ecto.Migration

  def change do
    create table(:bills, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :price, :decimal
      add :due_date, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
