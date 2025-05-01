defmodule BuddiesBackendWeb.HouseJSON do
  alias BuddiesBackend.Houses.House

  @doc """
  Renders a list of houses.
  """
  def index(%{houses: houses}) do
    %{data: for(house <- houses, do: data(house))}
  end

  @doc """
  Renders a single house.
  """
  def show(%{house: house}) do
    %{data: data(house)}
  end

  defp data(%House{} = house) do
    %{
      id: house.id,
      location: house.location,
      address: house.address
    }
  end
end
