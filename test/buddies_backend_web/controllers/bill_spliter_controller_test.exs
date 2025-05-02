defmodule BuddiesBackendWeb.BillSpliterControllerTest do
  use BuddiesBackendWeb.ConnCase

  import BuddiesBackend.BillSplitersFixtures

  alias BuddiesBackend.Managements.BillSpliter

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all billspliters", %{conn: conn} do
      conn = get(conn, ~p"/api/billspliters")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bill_spliter" do
    test "renders bill_spliter when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/billspliters", bill_spliter: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/billspliters/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/billspliters", bill_spliter: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bill_spliter" do
    setup [:create_bill_spliter]

    test "renders bill_spliter when data is valid", %{
      conn: conn,
      bill_spliter: %BillSpliter{id: id} = bill_spliter
    } do
      conn = put(conn, ~p"/api/billspliters/#{bill_spliter}", bill_spliter: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/billspliters/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bill_spliter: bill_spliter} do
      conn = put(conn, ~p"/api/billspliters/#{bill_spliter}", bill_spliter: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bill_spliter" do
    setup [:create_bill_spliter]

    test "deletes chosen bill_spliter", %{conn: conn, bill_spliter: bill_spliter} do
      conn = delete(conn, ~p"/api/billspliters/#{bill_spliter}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/billspliters/#{bill_spliter}")
      end
    end
  end

  defp create_bill_spliter(_) do
    bill_spliter = bill_spliter_fixture()
    %{bill_spliter: bill_spliter}
  end
end
