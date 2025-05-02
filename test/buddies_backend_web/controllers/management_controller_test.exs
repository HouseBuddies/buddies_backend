defmodule BuddiesBackendWeb.ManagementControllerTest do
  use BuddiesBackendWeb.ConnCase

  import BuddiesBackend.ManagementsFixtures

  alias BuddiesBackend.Managements.Management

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all managements", %{conn: conn} do
      conn = get(conn, ~p"/api/managements")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create management" do
    test "renders management when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/managements", management: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/managements/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/managements", management: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update management" do
    setup [:create_management]

    test "renders management when data is valid", %{conn: conn, management: %Management{id: id} = management} do
      conn = put(conn, ~p"/api/managements/#{management}", management: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/managements/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, management: management} do
      conn = put(conn, ~p"/api/managements/#{management}", management: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete management" do
    setup [:create_management]

    test "deletes chosen management", %{conn: conn, management: management} do
      conn = delete(conn, ~p"/api/managements/#{management}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/managements/#{management}")
      end
    end
  end

  defp create_management(_) do
    management = management_fixture()
    %{management: management}
  end
end
