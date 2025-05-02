defmodule BuddiesBackendWeb.ManagementJSON do
  alias BuddiesBackend.Managements.Management

  @doc """
  Renders a list of managements.
  """
  def index(%{managements: managements}) do
    %{data: for(management <- managements, do: data(management))}
  end

  @doc """
  Renders a single management.
  """
  def show(%{management: management}) do
    %{data: data(management)}
  end

  defp data(%Management{} = management) do
    %{
      id: management.id
    }
  end
end
