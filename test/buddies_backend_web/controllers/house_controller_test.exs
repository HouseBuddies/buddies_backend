defmodule BuddiesBackendWeb.HouseControllerTest do
  use BuddiesBackendWeb.ConnCase

  import BuddiesBackend.HousesFixtures

  alias BuddiesBackend.Houses.House

  @create_attrs %{
    address: "some address",
    location: "some location"
  }
  @update_attrs %{
    address: "some updated address",
    location: "some updated location"
  }
  @invalid_attrs %{address: nil, location: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all houses", %{conn: conn} do
      conn = get(conn, ~p"/api/houses")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create house" do
    test "renders house when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/houses", house: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/houses/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some address",
               "location" => "some location"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/houses", house: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update house" do
    setup [:create_house]

    test "renders house when data is valid", %{conn: conn, house: %House{id: id} = house} do
      conn = put(conn, ~p"/api/houses/#{house}", house: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/houses/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "location" => "some updated location"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, house: house} do
      conn = put(conn, ~p"/api/houses/#{house}", house: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete house" do
    setup [:create_house]

    test "deletes chosen house", %{conn: conn, house: house} do
      conn = delete(conn, ~p"/api/houses/#{house}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/houses/#{house}")
      end
    end
  end

  defp create_house(_) do
    house = house_fixture()
    %{house: house}
  end
end
