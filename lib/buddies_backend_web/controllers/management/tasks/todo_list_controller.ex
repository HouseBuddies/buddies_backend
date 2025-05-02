defmodule BuddiesBackendWeb.TodoListController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.TodoLists
  alias BuddiesBackend.Managements.TodoList

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, _params) do
    todolists = TodoLists.list_todolists()
    render(conn, :index, todolists: todolists)
  end

  def create(conn, %{"todo_list" => todo_list_params}) do
    with {:ok, %TodoList{} = todo_list} <- TodoLists.create_todo_list(todo_list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/todolists/#{todo_list}")
      |> render(:show, todo_list: todo_list)
    end
  end

  def show(conn, %{"id" => id}) do
    todo_list = TodoLists.get_todo_list!(id)
    render(conn, :show, todo_list: todo_list)
  end

  def update(conn, %{"id" => id, "todo_list" => todo_list_params}) do
    todo_list = TodoLists.get_todo_list!(id)

    with {:ok, %TodoList{} = todo_list} <- TodoLists.update_todo_list(todo_list, todo_list_params) do
      render(conn, :show, todo_list: todo_list)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo_list = TodoLists.get_todo_list!(id)

    with {:ok, %TodoList{}} <- TodoLists.delete_todo_list(todo_list) do
      send_resp(conn, :no_content, "")
    end
  end
end
