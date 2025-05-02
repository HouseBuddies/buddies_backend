defmodule BuddiesBackendWeb.TodoListJSON do
  alias BuddiesBackend.Managements.TodoList

  @doc """
  Renders a list of todolists.
  """
  def index(%{todolists: todolists}) do
    %{data: for(todo_list <- todolists, do: data(todo_list))}
  end

  @doc """
  Renders a single todo_list.
  """
  def show(%{todo_list: todo_list}) do
    %{data: data(todo_list)}
  end

  defp data(%TodoList{} = todo_list) do
    %{
      id: todo_list.id
    }
  end
end
