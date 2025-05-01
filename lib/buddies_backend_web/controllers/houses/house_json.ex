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
      rent: house.rent,
      rooms: house.rooms,
      available_date: house.available_date,
      address: house.address,
      max_residents: house.max_residents,
      tags: house.tags,
      created_at: house.inserted_at,
      residents: house.residents,
    }
  end
end
