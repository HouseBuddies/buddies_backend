defmodule BuddiesBackendWeb.TaskController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Tasks
  alias BuddiesBackend.TodoLists
  alias BuddiesBackend.Tasks.Task

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, %{"house_id" => house_id}) do
    tasks = Tasks.list_tasks_by_house(house_id)

    render(conn, :index, tasks: tasks)
  end

  def create(conn, %{"creator_id" => creator_id, "house_id" => house_id, "task" => task_params}) do
    todo_list = TodoLists.get_todo_list_by_house_id(house_id)

    task_params =
      task_params
      |> Map.put("creator_id", creator_id)
      |> Map.put("todo_list_id", todo_list.id)


    IO.inspect(task_params, label: "Task Params")

    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
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
