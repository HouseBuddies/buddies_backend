defmodule BuddiesBackend.Repo.Seeds.Accounts do
  alias BuddiesBackend.Accounts
  alias BuddiesBackend.Repo
  alias BuddiesBackend.Accounts.User

  @names File.read!("priv/fake/names.txt") |> String.split("\n")

  def run do
    names = @names
    case Accounts.list_users() do
      [] ->
        seed_users(names)
      _  ->
        Mix.shell().error("Found accounts, aborting seeding attendees.")
    end
  end

  def seed_users(names) do
    for name <- names do
      email = (name |> String.downcase() |> String.replace(~r/\s*/, "")) <> "@mail.pt"

      attrs = %{
        "name" => name,
        "email" => email,
        "age" => Enum.random(20..30),
        "photo" => "https://randomuser.me/api/portraits/#{Enum.random(["men", "women"])}/#{Enum.random(1..99)}.jpg",
        "password" => "password1234",
        "password_confirmation" => "password1234"
      }

      case User.registration_changeset(%User{}, attrs) |> Repo.insert() do
        {:ok, user} ->
          interests =
            %{
              gender: [:male, :female, :non_binary] |> Enum.random(),
              occupation: [:student, :full_time, :part_time, :freelance, :unemployed, :retired] |> Enum.random(),
              work_schedule: [:remote, :on_site, :day_shift, :night_shift, :weekends, :rotating] |> Enum.random(),
              desired_cleanliness: Enum.random(1..5),
              noise_tolerance: Enum.random(1..5),
              sleep_schedule: [:early_bird, :night_owl, :regular, :variable] |> Enum.random(),
              smoker: Enum.random([true, false]),
              alcohol: [:never, :occasional, :regular] |> Enum.random(),
              visitors: Enum.random(1..5),
              max_rent: Enum.random(400..1500),
              location: ["Braga", "Porto", "Lisboa", "Coimbra", "Aveiro"] |> Enum.random(),
            }

          User.preferences_changeset(user, interests) |> Repo.update()

          Mix.shell().info("Created user: #{user.name} (#{user.email})")
        {:error, changeset} ->
          Mix.shell().error(Kernel.inspect(changeset.errors))
      end
    end
  end
end

BuddiesBackend.Repo.Seeds.Accounts.run()
