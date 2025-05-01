defmodule BuddiesBackend.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start_date , :utc_datetime
      add :end_date, :utc_datetime
      add :price, :decimal
      add :plan_id, references(:plans, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
