defmodule BuddiesBackendWeb.ActivityJSON do
  alias BuddiesBackend.Activities.Activity

  @doc """
  Renders a list of activities.
  """
  def index(%{activities: activities}) do
    %{data: for(activity <- activities, do: data(activity))}
  end

  @doc """
  Renders a single activity.
  """
  def show(%{activity: activity}) do
    %{data: data(activity)}
  end

  defp data(%Activity{} = activity) do
    %{
      id: activity.id,
      start_date: activity.start_date,
      end_date: activity.end_date,
      title: activity.title,
      description: activity.description,
      created_by: %{
        id: activity.created_by.id,
        name: activity.created_by.name,
        email: activity.created_by.email,
        age: activity.created_by.age
      }
    }
  end
end
