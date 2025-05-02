defmodule BuddiesBackend.Repo.Migrations.CreateShoppingcarts do
  use Ecto.Migration

  def change do
    create table(:shoppingcarts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :management_id, references(:managements, type: :binary_id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
