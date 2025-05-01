defmodule BuddiesBackend.Repo.Seeds.Houses do
  alias BuddiesBackend.Houses

  def run do
    case Houses.list_houses() do
      [] ->
        seed_houses()
      _  ->
        Mix.shell().error("Found accounts, aborting seeding attendees.")
    end
  end

  def seed_houses do
    # TODO: Add houses with valid portuguese addresses
  end
end

BuddiesBackend.Repo.Seeds.Houses.run()
