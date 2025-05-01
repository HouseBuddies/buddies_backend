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

  defp data(%UserHouse{} = user_house) do
    %{
      id: user_house.id,
      house: user_house.house,
      user: user_house.user,
      type: user_house.type,
    }
  end
end
