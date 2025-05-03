defmodule BuddiesBackendWeb.ActivityController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Activities
  alias BuddiesBackend.Activities.Activity
  alias BuddiesBackend.Calendars

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, %{"house_id" => house_id}) do
    activities = Activities.list_activities_by_house(house_id)
    render(conn, :index, activities: activities)
  end

  def create(conn, %{"activity" => activity_params, "created_by_id" => created_by_id, "house_id" => house_id}) do
    calendar = Calendars.get_calendar_by_house_id(house_id)

    activity_params =
      activity_params
      |> Map.put("created_by_id", created_by_id)
      |> Map.put("calendar_id", calendar.id)

    IO.inspect(activity_params, label: "Activity Params")

    with {:ok, %Activity{} = activity} <- Activities.create_activity(activity_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/activities/#{activity}")
      |> render(:show, activity: activity)
    end
  end

  def show(conn, %{"id" => id}) do
    activity = Activities.get_activity!(id)
    render(conn, :show, activity: activity)
  end

  def update(conn, %{"id" => id, "activity" => activity_params}) do
    activity = Activities.get_activity!(id)

    with {:ok, %Activity{} = activity} <- Activities.update_activity(activity, activity_params) do
      render(conn, :show, activity: activity)
    end
  end

  def delete(conn, %{"id" => id}) do
    activity = Activities.get_activity!(id)

    with {:ok, %Activity{}} <- Activities.delete_activity(activity) do
      send_resp(conn, :no_content, "")
    end
  end
end
