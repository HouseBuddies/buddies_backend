defmodule BuddiesBackendWeb.UserHouseJSON do
  alias BuddiesBackend.Houses.UserHouse

  @doc """
  Renders a list of user_houses.
  """
  def index(%{user_houses: user_houses}) do
    %{data: for(user_house <- user_houses, do: data(user_house))}
  end

  @doc """
  Renders a single user_house.
  """
  def show(%{user_house: user_house}) do
    %{data: data(user_house)}
  end

  def show_confirm(%{user_house: user_house}) do
    %{data: data_confirm(user_house)}
  end

  def show_boolean(%{value: value}) do
    %{data: %{value: value}}
  end

  defp data_confirm(%UserHouse{} = user_house) do
    %{ id: user_house.id }
  end

  defp data(%UserHouse{type: :favorite} = user_house) do
    %{
      id: user_house.id,
      user: %{
        id: user_house.user.id,
        name: user_house.user.name,
        email: user_house.user.email,
        age: user_house.user.age,
      },
      house: %{
        id: user_house.house.id,
        image: user_house.house.image,
        address: user_house.house.address,
        min_rent: user_house.house.min_rent,
        max_rent: user_house.house.max_rent,
        available_date: user_house.house.available_date,
        max_residents: user_house.house.max_residents,
        rooms: user_house.house.rooms,
        tags: user_house.house.tags
      },
    }
  end

  defp data(%UserHouse{} = user_house) do
    %{
      id: user_house.id,
      user: %{
        id: user_house.user.id,
        name: user_house.user.name,
        email: user_house.user.email,
        age: user_house.user.age,
        location: user_house.user.location
      },
      type: user_house.type
    }
  end
end
