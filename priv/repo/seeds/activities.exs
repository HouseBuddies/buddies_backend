defmodule BuddiesBackend.Repo.Seeds.Activities do
  alias BuddiesBackend.Activities.Activity
  alias BuddiesBackend.Repo
  alias BuddiesBackend.Accounts.User
  alias BuddiesBackend.Managements.Calendar

  def run do
    case Repo.all(Activity) do
      [] ->
        seed_activities()

      _ ->
        Mix.shell().error("Found activities, aborting seeding activities.")
    end
  end

  defp seed_activities do
    users = Repo.all(User)
    calendars = Repo.all(Calendar)

    activities = [
      %{
        "title" => "Meeting with team",
        "description" => "Discuss project updates",
        "start_date" => DateTime.utc_now(),
        "end_date" => DateTime.utc_now() |> DateTime.add(2, :hour),
      },
      %{
        "title" => "Project deadline",
        "description" => "Submit final report",
        "start_date" => DateTime.utc_now(),
        "end_date" => DateTime.utc_now() |> DateTime.add(1, :day),
      },
      %{
        "title" => "Code review",
        "description" => "Review pull requests",
        "start_date" => DateTime.utc_now(),
        "end_date" => DateTime.utc_now() |> DateTime.add(3, :hour),
      },
      %{
        "title" => "Team lunch",
        "description" => "Lunch with the roomates",
        "start_date" => DateTime.utc_now(),
        "end_date" => DateTime.utc_now() |> DateTime.add(1, :hour),
      }
    ]

    for calendar <- calendars do
      for _ <- 1..10 do
        user = Enum.random(users)
        activity_data = Enum.random(activities)

        %Activity{}
        |> Activity.changeset(Map.merge(activity_data, %{
          "created_by_id" => user.id,
          "calendar_id" => calendar.id
        }))
        |> Repo.insert!()
      end
    end
  end
end

BuddiesBackend.Repo.Seeds.Activities.run()
