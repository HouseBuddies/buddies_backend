defmodule BuddiesBackend.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        due_date: ~U[2025-04-30 23:07:00Z],
        finished: true,
        title: "some title"
      })
      |> BuddiesBackend.Tasks.create_task()

    task
  end
end
