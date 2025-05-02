defmodule BuddiesBackendWeb.ShoppingCartController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.ShoppingCarts
  alias BuddiesBackend.Managements.ShoppingCart

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, _params) do
    shoppingcarts = ShoppingCarts.list_shoppingcarts()
    render(conn, :index, shoppingcarts: shoppingcarts)
  end

  def create(conn, %{"shopping_cart" => shopping_cart_params}) do
    with {:ok, %ShoppingCart{} = shopping_cart} <-
           ShoppingCarts.create_shopping_cart(shopping_cart_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/shoppingcarts/#{shopping_cart}")
      |> render(:show, shopping_cart: shopping_cart)
    end
  end

  def show(conn, %{"id" => id}) do
    shopping_cart = ShoppingCarts.get_shopping_cart!(id)
    render(conn, :show, shopping_cart: shopping_cart)
  end

  def update(conn, %{"id" => id, "shopping_cart" => shopping_cart_params}) do
    shopping_cart = ShoppingCarts.get_shopping_cart!(id)

    with {:ok, %ShoppingCart{} = shopping_cart} <-
           ShoppingCarts.update_shopping_cart(shopping_cart, shopping_cart_params) do
      render(conn, :show, shopping_cart: shopping_cart)
    end
  end

  def delete(conn, %{"id" => id}) do
    shopping_cart = ShoppingCarts.get_shopping_cart!(id)

    with {:ok, %ShoppingCart{}} <- ShoppingCarts.delete_shopping_cart(shopping_cart) do
      send_resp(conn, :no_content, "")
    end
  end
end
