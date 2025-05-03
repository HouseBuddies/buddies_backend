defmodule BuddiesBackend.Repo.Seeds.Products do
  @moduledoc """
  Script for populating the database with products.
  You can run it as:
    $ mix run priv/repo/seeds/products.exs
  """
  alias BuddiesBackend.Repo
  alias BuddiesBackend.Products.Product
  alias BuddiesBackend.Managements.ShoppingCart
  alias BuddiesBackend.Accounts.User

  def run do
    case BuddiesBackend.Products.list_products() do
      [] ->
        seed_products()

      _ ->
        Mix.shell().error("Found products, aborting seeding products.")
    end
  end

  def seed_products do
    shopping_carts = Repo.all(ShoppingCart)
    users = Repo.all(User)

    for shopping_cart <- shopping_carts do
      for _ <- 1..10 do
        user = Enum.random(users)

        product_data = %{
          "name" => "Product #{Enum.random(1..100)}",
          "description" => "Description for Product #{Enum.random(1..100)}",
          "price" => Enum.random(10..100),
          "quantity" => Enum.random(1..10),
          "shopping_cart_id" => shopping_cart.id,
          "created_by_id" => user.id
        }

        %Product{}
        |> Product.changeset(product_data)
        |> Repo.insert!()
      end
    end
  end
end

BuddiesBackend.Repo.Seeds.Products.run()
