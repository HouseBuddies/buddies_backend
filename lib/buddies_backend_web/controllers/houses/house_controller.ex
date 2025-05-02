defmodule BuddiesBackendWeb.HouseController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Houses
  alias BuddiesBackend.Houses.House

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, _params) do
    houses = Houses.list_houses()
    render(conn, :index, houses: houses)
  end

  def create(
        conn,
        %{
          "address" => address,
          "available_date" => available_date,
          "max_residents" => max_residents,
          "owner_id" => owner_id,
          "min_rent" => min_rent,
          "max_rent" => max_rent,
          "rooms" => rooms
        } = _attrs
      ) do
    max_residents = String.to_integer(max_residents)
    min_rent = String.to_integer(min_rent)
    max_rent = String.to_integer(max_rent)
    rooms = String.to_integer(rooms)
    {:ok, datetime, 9000} = DateTime.from_iso8601(available_date)

    cleaned_params = %{
      "address" => address,
      "available_date" => datetime,
      "max_residents" => max_residents,
      "owner_id" => owner_id,
      "min_rent" => min_rent,
      "max_rent" => max_rent,
      "rooms" => rooms
    }

    # Create the house using the cleaned-up parameters
    with {:ok, %House{} = house} <- Houses.create_house(cleaned_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/houses/#{house.id}")
      |> render(:show, house: house)
    end
  end

  def show(conn, %{"id" => id}) do
    house = Houses.get_house!(id)
    render(conn, :show, house: house)
  end

  def update(conn, attrs) do
    {house, _} = Houses.get_house!(Map.get(attrs, "id"))

    house_params =
      attrs
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      |> Enum.into(%{})


    with {:ok, %House{} = house} <- Houses.update_house(house, house_params) do
      render(conn, :show, house: house)
    end
  end


  def delete(conn, %{"id" => id}) do
    {house, _user} = Houses.get_house!(id)

    with {:ok, %House{}} <- Houses.delete_house(house) do
      send_resp(conn, :no_content, "")
    end
  end
end
