defmodule BuddiesBackendWeb.TaskController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Tasks
  alias BuddiesBackend.Tasks.Task

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, %{"house_id" => house_id}) do
    tasks = Tasks.list_tasks_by_house(house_id)

    render(conn, :index, tasks: tasks)
  end

  def create(conn, attrs) do
    with {:ok, due_date_str} <- Map.fetch(attrs, "due_date"),
        {:ok, datetime, _offset} <- DateTime.from_iso8601(due_date_str),
        todo_list_id <- Map.get(attrs, "todo_list_id"),
        merged_attrs <-
          attrs
          |> Map.drop(["due_date"])
          |> Map.merge(%{"due_date" => datetime, "todo_list_id" => todo_list_id}),
        {:ok, %Task{} = task} <- Tasks.create_task(merged_attrs) do

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tasks/#{task}")
      |> render(:show, task: task)
    else
      :error -> send_resp(conn, 400, "Missing due_date")
      {:error, reason} -> send_resp(conn, 400, "Invalid due_date: #{inspect(reason)}")
    end
  end


  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, :show, task: task)
  end

  def update(conn, task_params) do
    task = Tasks.get_task!(Map.get(task_params, "id"))

    with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
      render(conn, :show, task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{}} <- Tasks.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end
