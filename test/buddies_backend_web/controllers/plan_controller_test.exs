defmodule BuddiesBackendWeb.PlanControllerTest do
  use BuddiesBackendWeb.ConnCase

  import BuddiesBackend.PlansFixtures

  alias BuddiesBackend.Plans.Plan

  @create_attrs %{
    name: "some name",
    description: "some description",
    price: "120.5"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    price: "456.7"
  }
  @invalid_attrs %{name: nil, description: nil, price: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all plans", %{conn: conn} do
      conn = get(conn, ~p"/api/plans")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create plan" do
    test "renders plan when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/plans", plan: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/plans/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "some name",
               "price" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/plans", plan: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update plan" do
    setup [:create_plan]

    test "renders plan when data is valid", %{conn: conn, plan: %Plan{id: id} = plan} do
      conn = put(conn, ~p"/api/plans/#{plan}", plan: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/plans/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "name" => "some updated name",
               "price" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, plan: plan} do
      conn = put(conn, ~p"/api/plans/#{plan}", plan: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete plan" do
    setup [:create_plan]

    test "deletes chosen plan", %{conn: conn, plan: plan} do
      conn = delete(conn, ~p"/api/plans/#{plan}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/plans/#{plan}")
      end
    end
  end

  defp create_plan(_) do
    plan = plan_fixture()
    %{plan: plan}
  end
end
