defmodule BuddiesBackendWeb.ProductController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Products
  alias BuddiesBackend.Products.Product
  alias BuddiesBackend.ShoppingCarts

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, %{"house_id" => house_id}) do
    products = Products.list_products_by_house(house_id)
    render(conn, :index, products: products)
  end

  def create(conn, %{
        "house_id" => house_id,
        "payload" => %{
          "created_by" => user_id,
          "description" => description,
          "name" => name,
          "quantity" => quantity
        }
      }) do
    IO.inspect(user_id, label: "User ID")
    shopping_cart = ShoppingCarts.get_shopping_cart_by_house_id(house_id)

    product_params = %{
      "name" => name,
      "description" => description,
      "quantity" => quantity,
      "state" => "available",
      "shopping_cart_id" => shopping_cart.id,
      "created_by_id" => user_id
    }

    with {:ok, %Product{} = product} <- Products.create_product(product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/products/#{product}")
      |> render(:show, product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    render(conn, :show, product: product)
  end

  def update(
        conn,
        %{"house_id" => _house_id, "id" => id, "state" => "purchased", "user_id" => user_id} =
          _params
      ) do
    product = Products.get_product!(id)

    product_params = %{
      "state" => "purchased",
      "purchased_by_id" => user_id
    }

    with {:ok, %Product{} = product} <- Products.update_product(product, product_params) do
      render(conn, :show, product: product)
    end
  end

  def update(
        conn,
        %{"house_id" => _house_id, "id" => id, "state" => "available", "user_id" => _user_id} =
          _params
      ) do
    product = Products.get_product!(id)

    product_params = %{
      "state" => "available"
    }

    with {:ok, %Product{} = product} <- Products.update_product(product, product_params) do
      render(conn, :show, product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Products.get_product!(id)

    with {:ok, %Product{}} <- Products.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end
end
