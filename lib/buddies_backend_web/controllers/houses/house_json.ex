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

  defp data(%House{} = house) do
    %{
      id: house.id,
      image: house.image,
      address: house.address,
      min_rent: house.min_rent,
      max_rent: house.max_rent,
      available_date: house.available_date,
      max_residents: house.max_residents,
      rooms: house.rooms,
      tags: house.tags,
      owner: %{
        name: house.owner.name,
        email: house.owner.email,
        age: house.owner.age,
        photo: house.owner.photo,
      }
    }
  end

  defp data(%House{} = house) do
    %{
      id: house.id,
      image: house.image,
      address: house.address,
      min_rent: house.min_rent,
      max_rent: house.max_rent,
      available_date: house.available_date,
      max_residents: house.max_residents,
      rooms: house.rooms,
      tags: house.tags
    }
  end

  defp data({%House{subscription_id: nil} = house, %User{} = user}) do
    %{
      id: house.id,
      image: house.image,
      min_rent: house.min_rent,
      max_rent: house.max_rent,
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
        photo: user.photo,
        location: user.location,
        confirmed_at: user.confirmed_at,
        first_time_login: user.first_time_login
      },
      subscription: nil
    }
  end

  defp data({%House{} = house, %User{} = user, nil}) do
    %{
      id: house.id,
      image: house.image,
      min_rent: house.min_rent,
      max_rent: house.max_rent,
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
        photo: user.photo,
        location: user.location,
        confirmed_at: user.confirmed_at,
        first_time_login: user.first_time_login
      },
      subscription: nil
    }
  end

  defp data({%House{} = house, %User{} = user}) do
    %{
      id: house.id,
      image: house.image,
      min_rent: house.min_rent,
      max_rent: house.max_rent,
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
        photo: user.photo,
        location: user.location,
        confirmed_at: user.confirmed_at,
        first_time_login: user.first_time_login
      },
      subscription: %{
        id: house.subscription.id,
        start_date: house.subscription.start_date,
        end_date: house.subscription.end_date,
        price: house.subscription.price
      }
    }
  end

  defp data({%House{} = house, %User{} = user, %BuddiesBackend.Subscriptions.Subscription{} = subscription}) do
    %{
      id: house.id,
      image: house.image,
      min_rent: house.min_rent,
      max_rent: house.max_rent,
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
        photo: user.photo,
        location: user.location,
        confirmed_at: user.confirmed_at,
        first_time_login: user.first_time_login
      },
      subscription: %{
        id: subscription.id,
        start_date: subscription.start_date,
        end_date: subscription.end_date,
        price: subscription.price
      }
    }
  end
end
