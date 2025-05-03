defmodule BuddiesBackend.Houses do
  @moduledoc """
  The Houses context.
  """

  import Ecto.Query, warn: false
  alias BuddiesBackend.Accounts
  alias BuddiesBackend.Accounts.User
  alias BuddiesBackend.BillSpliters
  alias BuddiesBackend.Calendars
  alias BuddiesBackend.Houses
  alias BuddiesBackend.Houses.House
  alias BuddiesBackend.Houses.UserHouse
  alias BuddiesBackend.Managements
  alias BuddiesBackend.Managements.BillSpliter
  alias BuddiesBackend.Managements.Calendar
  alias BuddiesBackend.Managements.Management
  alias BuddiesBackend.Managements.ShoppingCart
  alias BuddiesBackend.Managements.TodoList
  alias BuddiesBackend.Repo
  alias BuddiesBackend.ShoppingCarts
  alias BuddiesBackend.Subscriptions.Subscription
  alias BuddiesBackend.TodoLists



  @doc """
  Returns the list of houses.

  ## Examples

      iex> list_houses()
      [%House{}, ...]

  """
  def list_houses do
    from(h in House,
      join: uh in UserHouse,
      on: uh.house_id == h.id and uh.type == :owner,
      join: u in User,
      on: u.id == uh.user_id,
      preload: [:subscription],
      select: {h, u}
    )
    |> Repo.all()
  end

  @doc """
  Gets a single house.

  Raises `Ecto.NoResultsError` if the House does not exist.

  ## Examples

      iex> get_house!(123)
      %House{}

      iex> get_house!(456)
      ** (Ecto.NoResultsError)

  """
  def get_house!(id) do
    from(h in House,
      join: uh in UserHouse,
      on: uh.house_id == h.id and uh.type == :owner,
      join: u in User,
      on: u.id == uh.user_id,
      left_join: s in Subscription,
      on: s.id == h.subscription_id,
      where: h.id == ^id,
      select: {h, u, s}
    )
    |> Repo.one!()
  end


  @doc """
  Creates a house, assigns the user as the owner, and creates associated management entities.

  ## Examples

      iex> create_house(%{field: value}, user_id)
      {:ok, %House{}}

      iex> create_house(%{field: bad_value}, user_id)
      {:error, %Ecto.Changeset{}}

  """
  def create_house(attrs \\ %{}) do
    user_id = Map.get(attrs, "owner_id", "")

    Repo.transaction(fn ->
      house =
        %House{}
        |> House.changeset(attrs)
        |> Repo.insert!()

      %UserHouse{}
      |> UserHouse.changeset(%{house_id: house.id, user_id: user_id, type: "owner"})
      |> Repo.insert!()

      {:ok, management} = Managements.create_management(%{house_id: house.id})

      {:ok, bill_spliter} = BillSpliters.create_bill_spliter(%{management_id: management.id})
      {:ok, calendar} = Calendars.create_calendar(%{management_id: management.id})
      {:ok, shopping_cart} = ShoppingCarts.create_shopping_cart(%{management_id: management.id})
      {:ok, todo_list} = TodoLists.create_todo_list(%{management_id: management.id})

      Managements.update_management(
        management,
        %{
          bill_spliter_id: bill_spliter.id,
          calendar_id: calendar.id,
          shopping_cart: shopping_cart.id,
          todo_list: todo_list.id
        }
      )

      house
    end)
    |> case do
      {:ok, house} -> {:ok, house}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Updates a house.

  ## Examples

      iex> update_house(house, %{field: new_value})
      {:ok, %House{}}

      iex> update_house(house, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_house(%House{} = house, attrs) do
    house
    |> House.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a house and its associated user_houses.

  ## Examples

      iex> delete_house(house)
      {:ok, %House{}}

      iex> delete_house(house)
      {:error, %Ecto.Changeset{}}

  """
  def delete_house(%House{} = house) do
    house_id = house.id

    Repo.transaction(fn ->
      from(uh in UserHouse, where: uh.house_id == ^house_id)
      |> Repo.delete_all()

      Repo.delete(house)
    end)
    |> case do
      {:ok, _result} -> {:ok, house}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking house changes.

  ## Examples

      iex> change_house(house)
      %Ecto.Changeset{data: %House{}}

  """
  def change_house(%House{} = house, attrs \\ %{}) do
    House.changeset(house, attrs)
  end

  @doc """
  Returns the list of user_houses.

  ## Examples

      iex> list_user_houses()
      [%UserHouse{}, ...]

  """
  def list_user_houses do
    Repo.all(UserHouse)
  end

  @doc """
  Gets a single user_house.

  Raises `Ecto.NoResultsError` if the User house does not exist.

  ## Examples

      iex> get_user_house!(123)
      %UserHouse{}

      iex> get_user_house!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_house!(id) do
    Repo.get!(UserHouse, id)
    |> Repo.preload([:user, :house])
  end

  @doc """
  Creates a user_house.

  ## Examples

      iex> create_user_house(%{field: value})
      {:ok, %UserHouse{}}

      iex> create_user_house(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_house(attrs \\ %{}) do
    %UserHouse{}
    |> UserHouse.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_house.

  ## Examples

      iex> update_user_house(user_house, %{field: new_value})
      {:ok, %UserHouse{}}

      iex> update_user_house(user_house, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_house(%UserHouse{} = user_house, attrs) do
    user_house
    |> UserHouse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_house.

  ## Examples

      iex> delete_user_house(user_house)
      {:ok, %UserHouse{}}

      iex> delete_user_house(user_house)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_house(%UserHouse{} = user_house) do
    Repo.delete(user_house)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_house changes.

  ## Examples

      iex> change_user_house(user_house)
      %Ecto.Changeset{data: %UserHouse{}}

  """
  def change_user_house(%UserHouse{} = user_house, attrs \\ %{}) do
    UserHouse.changeset(user_house, attrs)
  end

  def get_house_residents(house_id) do
    from(uh in UserHouse,
      where: uh.house_id == ^house_id and uh.type == :resident,
      join: u in assoc(uh, :user),
      preload: [user: u]
    )
    |> Repo.all()
  end

  def get_house_owner(house_id) do
    from(uh in UserHouse,
      where: uh.house_id == ^house_id and uh.type == :owner,
      join: u in assoc(uh, :user),
      preload: [user: u]
    )
    |> Repo.one()
  end

  def get_user_matches(user_id) do
    from(uh in UserHouse,
      where: uh.user_id == ^user_id and uh.type == :match,
      join: u in assoc(uh, :user),
      preload: [user: u]
    )
    |> Repo.all()
  end

  def get_house_matches(house_id) do
    from(uh in UserHouse,
      where: uh.house_id == ^house_id and uh.type == :match,
      join: u in assoc(uh, :user),
      preload: [user: u]
    )
    |> Repo.all()
  end

  def favorite_house(house_id, user_id) do
    %UserHouse{}
    |> UserHouse.changeset(%{house_id: house_id, user_id: user_id, type: :favorite})
    |> Repo.insert()
  end

  def join_house(house_id, user_id) do
    %UserHouse{}
    |> UserHouse.changeset(%{house_id: house_id, user_id: user_id, type: :match})
    |> Repo.insert()
  end

  def get_user_favorite_houses(user_id) do
    from(uh in UserHouse,
      where: uh.user_id == ^user_id and uh.type == :favorite,
      join: u in assoc(uh, :user),
      join: h in assoc(uh, :house),
      preload: [user: u, house: h]
    )
    |> Repo.all()
  end

  def remove_favorite_house(house_id, user_id) do
    from(uh in UserHouse,
      where: uh.house_id == ^house_id and uh.user_id == ^user_id and uh.type == :favorite
    )
    |> Repo.delete_all()
  end

  def remove_join_house(house_id, user_id) do
    from(uh in UserHouse,
      where: uh.house_id == ^house_id and uh.user_id == ^user_id and uh.type == :match
    )
    |> Repo.delete_all()
  end

  def get_user_houses!(user_id) do
    from(uh in UserHouse,
      where: uh.user_id == ^user_id and uh.type in [:owner, :resident],
      join: u in assoc(uh, :user),
      join: h in assoc(uh, :house),
      preload: [user: u, house: h],
      select: {h, u, uh}
    )
    |> Repo.all()
  end

  def list_house_residents(house_id) do
    from(uh in UserHouse,
      where: uh.house_id == ^house_id and uh.type == :resident,
      join: u in assoc(uh, :user),
      preload: [user: u]
    )
    |> Repo.all()
    |> Enum.map(fn uh -> uh.user end)
  end

  def fetch_house_owner(house) do
    owner = get_house_owner(house.id)

    house
    |> Map.put(:owner, owner.user)
  end

  def list_higher_ranking_houses(user_id, location) do
    user = Accounts.get_user!(user_id)
    max_rent = user.max_rent

    # Get all houses where the address contains the location string, case-insensitive
    houses = Repo.all(
      from h in House,
        where: ilike(h.address, ^"%#{location}%")
        and h.max_rent <= ^max_rent
    )

    house_scores =
      Enum.map(houses, fn house ->
        residents = list_house_residents(house.id)

        scores =
          Enum.map(residents, fn res ->
            Accounts.similarity_score(user, res)
          end)

        avg_score = if length(scores) > 0, do: Enum.sum(scores) / length(scores), else: 0

        %{house: {house, get_house_owner(house.id).user, nil}, score: avg_score}
      end)

    Enum.sort_by(house_scores, & &1.score, :desc)
  end
end
