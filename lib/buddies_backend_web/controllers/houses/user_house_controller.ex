defmodule BuddiesBackendWeb.UserHouseController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Houses
  alias BuddiesBackend.Houses.UserHouse

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, _params) do
    user_houses = Houses.list_user_houses()
    render(conn, :index, user_houses: user_houses)
  end

  def create(conn, %{"user_house" => user_house_params}) do
    with {:ok, %UserHouse{} = user_house} <- Houses.create_user_house(user_house_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/user_houses/#{user_house}")
      |> render(:show, user_house: user_house)
    end
  end

  def show_house_residents(conn, %{"id" => house_id}) do
    user_houses = Houses.get_house_residents(house_id)
    render(conn, :index, user_houses: user_houses)
  end

  def show_house_owner(conn, %{"id" => house_id}) do
    user_house = Houses.get_house_owner(house_id)
    render(conn, :show, user_house: user_house)
  end

  def show_house_matches(conn, %{"id" => house_id}) do
    user_houses = Houses.get_house_matches(house_id)
    render(conn, :index, user_houses: user_houses)
  end

  def show(conn, %{"id" => id}) do
    user_house = Houses.get_user_house!(id)
    render(conn, :show, user_house: user_house)
  end

  def update(conn, %{"id" => id, "user_house" => user_house_params}) do
    user_house = Houses.get_user_house!(id)

    with {:ok, %UserHouse{} = user_house} <- Houses.update_user_house(user_house, user_house_params) do
      render(conn, :show, user_house: user_house)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_house = Houses.get_user_house!(id)

    with {:ok, %UserHouse{}} <- Houses.delete_user_house(user_house) do
      send_resp(conn, :no_content, "")
    end
  end
end
