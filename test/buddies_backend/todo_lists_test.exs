defmodule BuddiesBackend.TodoListsTest do
  use BuddiesBackend.DataCase

  alias BuddiesBackend.TodoLists

  describe "todolists" do
    alias BuddiesBackend.Managements.TodoList

    import BuddiesBackend.TodoListsFixtures

    @invalid_attrs %{}

    test "list_todolists/0 returns all todolists" do
      todo_list = todo_list_fixture()
      assert TodoLists.list_todolists() == [todo_list]
    end

    test "get_todo_list!/1 returns the todo_list with given id" do
      todo_list = todo_list_fixture()
      assert TodoLists.get_todo_list!(todo_list.id) == todo_list
    end

    test "create_todo_list/1 with valid data creates a todo_list" do
      valid_attrs = %{}

      assert {:ok, %TodoList{} = todo_list} = TodoLists.create_todo_list(valid_attrs)
    end

    test "create_todo_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TodoLists.create_todo_list(@invalid_attrs)
    end

    test "update_todo_list/2 with valid data updates the todo_list" do
      todo_list = todo_list_fixture()
      update_attrs = %{}

      assert {:ok, %TodoList{} = todo_list} = TodoLists.update_todo_list(todo_list, update_attrs)
    end

    test "update_todo_list/2 with invalid data returns error changeset" do
      todo_list = todo_list_fixture()
      assert {:error, %Ecto.Changeset{}} = TodoLists.update_todo_list(todo_list, @invalid_attrs)
      assert todo_list == TodoLists.get_todo_list!(todo_list.id)
    end

    test "delete_todo_list/1 deletes the todo_list" do
      todo_list = todo_list_fixture()
      assert {:ok, %TodoList{}} = TodoLists.delete_todo_list(todo_list)
      assert_raise Ecto.NoResultsError, fn -> TodoLists.get_todo_list!(todo_list.id) end
    end

    test "change_todo_list/1 returns a todo_list changeset" do
      todo_list = todo_list_fixture()
      assert %Ecto.Changeset{} = TodoLists.change_todo_list(todo_list)
    end
  end
end
