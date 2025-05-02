defmodule BuddiesBackendWeb.CalendarControllerTest do
  use BuddiesBackendWeb.ConnCase

  import BuddiesBackend.CalendarsFixtures

  alias BuddiesBackend.Managements.Calendar

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all calendars", %{conn: conn} do
      conn = get(conn, ~p"/api/calendars")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create calendar" do
    test "renders calendar when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/calendars", calendar: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/calendars/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/calendars", calendar: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update calendar" do
    setup [:create_calendar]

    test "renders calendar when data is valid", %{
      conn: conn,
      calendar: %Calendar{id: id} = calendar
    } do
      conn = put(conn, ~p"/api/calendars/#{calendar}", calendar: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/calendars/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, calendar: calendar} do
      conn = put(conn, ~p"/api/calendars/#{calendar}", calendar: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete calendar" do
    setup [:create_calendar]

    test "deletes chosen calendar", %{conn: conn, calendar: calendar} do
      conn = delete(conn, ~p"/api/calendars/#{calendar}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/calendars/#{calendar}")
      end
    end
  end

  defp create_calendar(_) do
    calendar = calendar_fixture()
    %{calendar: calendar}
  end
end
