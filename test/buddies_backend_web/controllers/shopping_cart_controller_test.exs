defmodule BuddiesBackendWeb.ShoppingCartControllerTest do
  use BuddiesBackendWeb.ConnCase

  import BuddiesBackend.ShoppingCartsFixtures

  alias BuddiesBackend.Managements.ShoppingCart

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all shoppingcarts", %{conn: conn} do
      conn = get(conn, ~p"/api/shoppingcarts")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create shopping_cart" do
    test "renders shopping_cart when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/shoppingcarts", shopping_cart: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/shoppingcarts/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/shoppingcarts", shopping_cart: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update shopping_cart" do
    setup [:create_shopping_cart]

    test "renders shopping_cart when data is valid", %{
      conn: conn,
      shopping_cart: %ShoppingCart{id: id} = shopping_cart
    } do
      conn = put(conn, ~p"/api/shoppingcarts/#{shopping_cart}", shopping_cart: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/shoppingcarts/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, shopping_cart: shopping_cart} do
      conn = put(conn, ~p"/api/shoppingcarts/#{shopping_cart}", shopping_cart: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete shopping_cart" do
    setup [:create_shopping_cart]

    test "deletes chosen shopping_cart", %{conn: conn, shopping_cart: shopping_cart} do
      conn = delete(conn, ~p"/api/shoppingcarts/#{shopping_cart}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/shoppingcarts/#{shopping_cart}")
      end
    end
  end

  defp create_shopping_cart(_) do
    shopping_cart = shopping_cart_fixture()
    %{shopping_cart: shopping_cart}
  end
end
