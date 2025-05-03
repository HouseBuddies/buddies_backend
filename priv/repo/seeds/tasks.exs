defmodule BuddiesBackend.Repo.Seeds.Tasks do
  @moduledoc """
  Script for populating the database with tasks.
  You can run it as:
    $ mix run priv/repo/seeds/tasks.exs
  """

  alias BuddiesBackend.Tasks
  alias BuddiesBackend.TodoLists

  @tasks File.read!("priv/fake/tasks.txt") |> String.split("\n")

  def run do
    case BuddiesBackend.Tasks.list_tasks() do
      [] ->
        seed_tasks()

      _ ->
        Mix.shell().error("Found tasks, aborting seeding tasks.")
    end
  end

  def seed_tasks do
    todo_lists = TodoLists.list_todolists() |> Enum.take(3)
    users = BuddiesBackend.Accounts.list_users() |> Enum.take(3)

    for todo_list <- todo_lists do
      for task <- Enum.take_random(@tasks, 3) do
        attrs = %{
          "title" => task,
          "description" => "Description for #{task}",
          "status" => :pending,
          "todo_list_id" => todo_list.id,
          "creator_id" => Enum.random(users).id,
          "due_date" => DateTime.utc_now() |> DateTime.add(Enum.random(0..30), :day)
        }

        case Tasks.create_task(attrs) do
          {:ok, task} ->
            Mix.shell().info("Created task: #{task.title}")

          {:error, changeset} ->
            Mix.shell().error(Kernel.inspect(changeset.errors))
        end
      end
    end
  end
end

BuddiesBackend.Repo.Seeds.Tasks.run()
