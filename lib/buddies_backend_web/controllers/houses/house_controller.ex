defmodule BuddiesBackendWeb.HouseController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Houses
  alias BuddiesBackend.Houses.House

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, _params) do
    houses = Houses.list_houses()
    render(conn, :index, houses: houses)
  end

  def create(conn, %{"house" => house_params}) do
    with {:ok, %House{} = house} <- Houses.create_house(house_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/houses/#{house}")
      |> render(:show, house: house)
    end
  end

  def show(conn, %{"id" => id}) do
    house = Houses.get_house!(id)
    render(conn, :show, house: house)
  end

  def update(conn, %{"id" => id, "house" => house_params}) do
    house = Houses.get_house!(id)

    with {:ok, %House{} = house} <- Houses.update_house(house, house_params) do
      render(conn, :show, house: house)
    end
  end

  def delete(conn, %{"id" => id}) do
    house = Houses.get_house!(id)

    with {:ok, %House{}} <- Houses.delete_house(house) do
      send_resp(conn, :no_content, "")
    end
  end
end
