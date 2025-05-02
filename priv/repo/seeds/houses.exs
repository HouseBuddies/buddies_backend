defmodule BuddiesBackend.Repo.Seeds.Houses do
  alias BuddiesBackend.Accounts
  alias BuddiesBackend.Houses
  alias BuddiesBackend.Repo
  alias BuddiesBackend.Houses.UserHouse

  @addresses File.read!("priv/fake/addresses.txt") |> String.split("\n")

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

      image_url = "/images/houses/#{Enum.random(0..59)}.jpg"

      owner = Enum.random(users)
      attrs = %{
        "image" => image_url,
        "address" => address,
        "min_rent" => min_rent,
        "max_rent" => max_rent,
        "rooms" => rooms,
        "available_date" => available_date,
        "owner_id" => owner.id
      }

      case Houses.create_house(attrs) do
        {:ok, house} ->
          Mix.shell().info("Created house: #{house.address} (#{house.min_rent} - #{house.max_rent})")

        {:error, changeset} ->
          Mix.shell().error(Kernel.inspect(changeset.errors))
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
          Mix.shell().info("Created successfully !")
        {:error, changeset} ->
          Mix.shell().error(Kernel.inspect(changeset.errors))
      end

      for user <- users do
        attrs = %{
          "user_id" => user.id,
          "house_id" => house.id,
          "type" => :resident,
        }

        case UserHouse.changeset(%UserHouse{}, attrs) |> Repo.insert() do
          {:ok, _user_house} ->
            Mix.shell().info("Created successfully !")

          {:error, changeset} ->
            Mix.shell().error(Kernel.inspect(changeset.errors))
        end
      end
    end
  end

end

BuddiesBackend.Repo.Seeds.Houses.run()
