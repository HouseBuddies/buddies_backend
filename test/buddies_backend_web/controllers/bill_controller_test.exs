defmodule BuddiesBackendWeb.BillControllerTest do
  use BuddiesBackendWeb.ConnCase

  import BuddiesBackend.BillsFixtures

  alias BuddiesBackend.Bills.Bill

  @create_attrs %{
    price: "120.5",
    due_date: ~U[2025-05-01 00:34:00Z]
  }
  @update_attrs %{
    price: "456.7",
    due_date: ~U[2025-05-02 00:34:00Z]
  }
  @invalid_attrs %{price: nil, due_date: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all bills", %{conn: conn} do
      conn = get(conn, ~p"/api/bills")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bill" do
    test "renders bill when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/bills", bill: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/bills/#{id}")

      assert %{
               "id" => ^id,
               "due_date" => "2025-05-01T00:34:00Z",
               "price" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/bills", bill: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bill" do
    setup [:create_bill]

    test "renders bill when data is valid", %{conn: conn, bill: %Bill{id: id} = bill} do
      conn = put(conn, ~p"/api/bills/#{bill}", bill: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/bills/#{id}")

      assert %{
               "id" => ^id,
               "due_date" => "2025-05-02T00:34:00Z",
               "price" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bill: bill} do
      conn = put(conn, ~p"/api/bills/#{bill}", bill: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bill" do
    setup [:create_bill]

    test "deletes chosen bill", %{conn: conn, bill: bill} do
      conn = delete(conn, ~p"/api/bills/#{bill}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/bills/#{bill}")
      end
    end
  end

  defp create_bill(_) do
    bill = bill_fixture()
    %{bill: bill}
  end
end
