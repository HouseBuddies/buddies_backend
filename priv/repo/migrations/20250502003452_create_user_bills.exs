defmodule BuddiesBackend.Repo.Migrations.CreateUserBills do
  use Ecto.Migration

  def change do
    create table(:user_bills, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :bill_id, references(:bills, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
