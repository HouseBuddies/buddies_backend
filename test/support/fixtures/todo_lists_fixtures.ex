defmodule BuddiesBackend.TodoListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.TodoLists` context.
  """

  @doc """
  Generate a todo_list.
  """
  def todo_list_fixture(attrs \\ %{}) do
    {:ok, todo_list} =
      attrs
      |> Enum.into(%{})
      |> BuddiesBackend.TodoLists.create_todo_list()

    todo_list
  end
end
