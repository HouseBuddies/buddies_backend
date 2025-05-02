defmodule BuddiesBackendWeb.HouseJSON do
  alias BuddiesBackend.Houses.House
  alias BuddiesBackend.Accounts.User

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

  defp data({%House{} = house, %User{} = user}) do
    %{
      id: house.id,
      image: house.image,
      rent: house.rent,
      rooms: house.rooms,
      available_date: house.available_date,
      address: house.address,
      max_residents: house.max_residents,
      tags: house.tags,
      created_at: house.inserted_at,
      owner: %{
        id: user.id,
        name: user.name,
        email: user.email,
        age: user.age,
        location: user.location,
        confirmed_at: user.confirmed_at,
        first_time_login: user.first_time_login
      }
    }
  end
end
