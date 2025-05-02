defmodule BuddiesBackendWeb.UserHouseControllerTest do
  use BuddiesBackendWeb.ConnCase

  import BuddiesBackend.HousesFixtures

  alias BuddiesBackend.Houses.UserHouse

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_houses", %{conn: conn} do
      conn = get(conn, ~p"/api/user_houses")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_house" do
    test "renders user_house when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_houses", user_house: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/user_houses/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_houses", user_house: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_house" do
    setup [:create_user_house]

    test "renders user_house when data is valid", %{
      conn: conn,
      user_house: %UserHouse{id: id} = user_house
    } do
      conn = put(conn, ~p"/api/user_houses/#{user_house}", user_house: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/user_houses/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_house: user_house} do
      conn = put(conn, ~p"/api/user_houses/#{user_house}", user_house: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_house" do
    setup [:create_user_house]

    test "deletes chosen user_house", %{conn: conn, user_house: user_house} do
      conn = delete(conn, ~p"/api/user_houses/#{user_house}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/user_houses/#{user_house}")
      end
    end
  end

  defp create_user_house(_) do
    user_house = user_house_fixture()
    %{user_house: user_house}
  end
end
