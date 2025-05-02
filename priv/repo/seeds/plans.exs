defmodule BuddiesBackend.Repo.Seeds.Plans do
  @moduledoc """
  Script for populating the database with plans.
  You can run it as:
    $ mix run priv/repo/seeds/plans.exs
  """

  alias BuddiesBackend.Repo
  alias BuddiesBackend.Plans.Plan

  def run do
    plans = [
      %{
        name: "Premium",
        description: "A premium house with all the amenities.",
        price: Decimal.new("9.99")
      }
    ]

    Enum.each(plans, fn plan ->
      Repo.insert!(%Plan{
        name: plan.name,
        description: plan.description,
        price: plan.price
      })
    end)
  end
end

BuddiesBackend.Repo.Seeds.Plans.run()
