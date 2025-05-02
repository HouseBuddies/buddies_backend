defmodule BuddiesBackend.Repo.Migrations.CreateManagements do
  use Ecto.Migration

  def change do
    create table(:managements, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :house_id, references(:houses, type: :binary_id, on_delete: :delete_all)
      add :bill_spliter_id, references(:billspliters, type: :binary_id, on_delete: :delete_all)
      add :calendar_id, references(:calendars, type: :binary_id, on_delete: :delete_all)
      add :shopping_cart_id, references(:shoppingcarts, type: :binary_id, on_delete: :delete_all)
      add :todo_list_id, references(:todolists, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
