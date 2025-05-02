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
      rent = Enum.random(500..1500)
      rooms = Enum.random(1..5)
      available_date = DateTime.utc_now() |> DateTime.add(Enum.random(0..30), :second)

      owner = Enum.random(users)
      attrs = %{
        "address" => address,
        "rent" => rent,
        "rooms" => rooms,
        "available_date" => available_date,
        "owner_id" => owner.id
      }

      case Houses.create_house(attrs) do
        {:ok, house} ->
          Mix.shell().info("Created house: #{house.address} (#{house.rent})")

        {:error, changeset} ->
          Mix.shell().error(Kernel.inspect(changeset.errors))
      end
    end

    seed_user_houses()
  end

  def seed_user_houses do
    users = Accounts.list_users()
    houses = Houses.list_houses()

    for house <- houses do
      # Ensure only one owner per house
      owner = Enum.find(users, fn user -> user.id == house.owner_id end)

      if owner do
        attrs = %{
          "user_id" => owner.id,
          "house_id" => house.id,
          "type" => :owner,
          "status" => :active
        }

        case UserHouse.changeset(%UserHouse{}, attrs) |> Repo.insert() do
          {:ok, _user_house} ->
            Mix.shell().info("Created user_house: #{owner.name} (#{owner.email}) as owner")

          {:error, changeset} ->
            Mix.shell().error(Kernel.inspect(changeset.errors))
        end
      end

      # Add other users as residents
      other_users = Enum.reject(users, fn user -> user.id == house.owner_id end)

      for user <- other_users do
        attrs = %{
          "user_id" => user.id,
          "house_id" => house.id,
          "type" => :resident,
          "status" => Enum.random([:active, :inactive])
        }

        case UserHouse.changeset(%UserHouse{}, attrs) |> Repo.insert() do
          {:ok, _user_house} ->
            Mix.shell().info("Created user_house: #{user.name} (#{user.email}) as resident")

          {:error, changeset} ->
            Mix.shell().error(Kernel.inspect(changeset.errors))
        end
      end
    end
  end
end

BuddiesBackend.Repo.Seeds.Houses.run()
