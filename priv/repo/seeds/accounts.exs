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
        "password" => "password1234",
        "password_confirmation" => "password1234"
      }

      case User.registration_changeset(%User{}, attrs) |> Repo.insert() do
        {:ok, user} ->
          Mix.shell().info("Created user: #{user.name} (#{user.email})")
        {:error, changeset} ->
          Mix.shell().error(Kernel.inspect(changeset.errors))
      end
    end
  end
end

BuddiesBackend.Repo.Seeds.Accounts.run()
