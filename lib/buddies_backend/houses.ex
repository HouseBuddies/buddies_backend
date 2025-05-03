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
      join: h in assoc(uh, :house),
      join: owner_uh in UserHouse,
      on: owner_uh.house_id == h.id and owner_uh.type == :owner,
      join: owner in assoc(owner_uh, :user),
      select: {h, owner}
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

  def get_match_score(user_id, house_id) do
    user = Accounts.get_user!(user_id)
    {house, _, _} = get_house!(house_id)

    # Get all residents of the house
    residents = list_house_residents(house.id)

    # Calculate the similarity score for each resident
    scores =
      Enum.map(residents, fn res ->
        Accounts.similarity_score(user, res)
      end)

    # Calculate the average score
    if length(scores) > 0, do: (Enum.sum(scores) / length(scores)) |> min(5), else: 0
  end

  def explain_match_score(user_id, house_id) do
    user = Accounts.get_user!(user_id)
    {house, _owner, _} = get_house!(house_id)

    # Get all residents of the house
    residents = list_house_residents(house.id)

    # Calculate the similarity score for each resident
    resident_scores = Enum.map(residents, fn resident ->
      score = Accounts.similarity_score(user, resident)
      %{
        score: score,
        age: resident.age,
        gender: resident.gender,
        occupation: resident.occupation,
        work_schedule: resident.work_schedule,
        desired_cleanliness: resident.desired_cleanliness,
        noise_tolerance: resident.noise_tolerance,
        sleep_schedule: resident.sleep_schedule,
        smoker: resident.smoker,
        alcohol: resident.alcohol,
        visitors: resident.visitors
      }
    end)

    # Create user profile data
    user_profile = %{
      name: user.name,
      age: user.age,
      gender: user.gender,
      occupation: user.occupation,
      work_schedule: user.work_schedule,
      desired_cleanliness: user.desired_cleanliness,
      noise_tolerance: user.noise_tolerance,
      sleep_schedule: user.sleep_schedule,
      smoker: user.smoker,
      alcohol: user.alcohol,
      visitors: user.visitors
    }

    # Calculate overall match score
    overall_score = if length(resident_scores) > 0 do
      (Enum.sum(Enum.map(resident_scores, & &1.score)) / length(resident_scores)) |> min(5)
    else
      0
    end

    # Prepare the prompt for Gemini AI
    prompt = """
    You are an AI assistant for a roommate matching application. Please provide a brief, friendly explanation (maximum 50 words) of why this user would be a good match for this house.
    Put an emoji at the end of your text.
    Visitors means how confortable the user is with having guests over. The higher the number, the more comfortable they are with it.
    Talk directly to the user.

    House information:
    - Address: #{house.address}
    - Monthly rent: $#{house.max_rent}
    - Number of residents: #{length(residents)}
    - Overall match score: #{Float.round(overall_score * 100, 1)}%

    User profile:
    #{Jason.encode!(user_profile, pretty: true)}

    Resident profiles and individual match scores:
    #{Jason.encode!(resident_scores, pretty: true)}

    Focus on the top 3 compatibility factors that make this a good match. Be specific about shared preferences and lifestyle compatibility.
    """ |> IO.inspect()

    # Make API request to Gemini AI
    api_key = Application.get_env(:buddies_backend, :gemini_api_key)

    request_body = %{
      contents: [
        %{
          parts: [
            %{
              text: prompt
            }
          ]
        }
      ],
      generationConfig: %{
        temperature: 0.7,
        maxOutputTokens: 800,
        topK: 40,
        topP: 0.95
      }
    }

    headers = [
      {"Content-Type", "application/json"},
      {"x-goog-api-key", api_key}
    ]

    case HTTPoison.post(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent",
      Jason.encode!(request_body),
      headers
    ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = Jason.decode!(body)

        # Extract the explanation text from the Gemini response
        explanation = case response do
          %{"candidates" => [%{"content" => %{"parts" => [%{"text" => text} | _]}} | _]} ->
            text
          _ ->
            "We couldn't generate an explanation for your match score at this time."
        end

        # Return the explanation along with the match score
        %{
          score: overall_score,
          explanation: explanation
        } |> IO.inspect()

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        %{
          score: overall_score,
          explanation: "Error getting match explanation. Status code: #{status_code}"
        } |> IO.inspect()

      {:error, %HTTPoison.Error{reason: reason}} ->
        %{
          score: overall_score,
          explanation: "Error getting match explanation: #{inspect(reason)}"
        } |> IO.inspect()
    end
  end
end
