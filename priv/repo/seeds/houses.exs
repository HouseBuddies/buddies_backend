defmodule BuddiesBackend.Repo.Seeds.Houses do
  alias BuddiesBackend.Accounts
  alias BuddiesBackend.Houses
  alias BuddiesBackend.Repo
  alias BuddiesBackend.Houses.UserHouse

  @addresses File.read!("priv/fake/addresses.txt") |> String.split("\n")
  @tags File.read!("priv/fake/tags.txt") |> String.split("\n")
  @likes_config File.read!("priv/fake/likes.json") |> Jason.decode!()
  @likes_options Map.new(@likes_config, fn %{"stateKey" => key, "options" => opts} ->
                   {key, opts}
                 end)

  def run do
    case Houses.list_houses() do
      [] ->
        seed_houses()

      _ ->
        Mix.shell().error("Found houses, aborting seeding houses.")
    end
  end

  def seed_houses do
    users = Accounts.list_users()

    for address <- @addresses do
      min_rent = Enum.random(250..400)
      max_rent = Enum.random(500..1500)
      rooms = Enum.random(1..5)
      available_date = DateTime.utc_now() |> DateTime.add(Enum.random(0..30), :second)

      likes = %{
        "selectedInterests" =>
          Enum.take_random(@likes_options["selectedInterests"], Enum.random(1..3)),
        "selectedGoals" => Enum.take_random(@likes_options["selectedGoals"], Enum.random(1..2)),
        "selectedNotifications" =>
          Enum.take_random(@likes_options["selectedNotifications"], Enum.random(1..2))
      }

      image_url = "/images/houses/#{Enum.random(0..59)}.jpg"

      owner = Enum.random(users)

      attrs = %{
        "image" => image_url,
        "address" => address,
        "min_rent" => min_rent,
        "max_rent" => max_rent,
        "rooms" => rooms,
        "available_date" => available_date,
        "tags" => Enum.take(Enum.shuffle(@tags), 5),
        "owner_id" => owner.id,
        "likes" => likes
      }

      case Houses.create_house(attrs) do
        {:ok, _house} ->
          :ok

        # Mix.shell().info("Created house: #{house.address} (#{house.min_rent} - #{house.max_rent})")

        {:error, _changeset} ->
          :ok
          # Mix.shell().error(Kernel.inspect(changeset.errors))
      end
    end

    seed_user_houses()
  end

  def seed_user_houses do
    users = Accounts.list_users()
    houses = Houses.list_houses()

    for {house, user} <- houses do
      attrs = %{
        "user_id" => user.id,
        "house_id" => house.id,
        "type" => :owner,
        "status" => :active
      }

      case UserHouse.changeset(%UserHouse{}, attrs) |> Repo.insert() do
        {:ok, _user_house} ->
          :ok

        {:error, _changeset} ->
          :ok
      end

      for user <- Enum.shuffle(users) |> Enum.take(5) do
        attrs = %{
          "user_id" => user.id,
          "house_id" => house.id,
          "type" => :resident
        }

        case UserHouse.changeset(%UserHouse{}, attrs) |> Repo.insert() do
          {:ok, _user_house} ->
            :ok

          {:error, changeset} ->
            :ok
        end
      end
    end
  end
end

BuddiesBackend.Repo.Seeds.Houses.run()
