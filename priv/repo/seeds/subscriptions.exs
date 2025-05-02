defmodule BuddiesBackend.Repo.Seeds.Subscriptions do
  @moduledoc """
  Script for populating the database with subscriptions.
  You can run it as:
    $ mix run priv/repo/seeds/subscriptions.exs
  """

  alias BuddiesBackend.Houses
  alias BuddiesBackend.Subscriptions
  alias BuddiesBackend.Plans

  def run do
    houses = Houses.list_houses() |> Enum.take(10)
    plan = Plans.get_plan_by_name!("Premium")
    IO.inspect(houses)
    Enum.each(houses, fn {house, _user} ->
      Subscriptions.create_subscription(%{
        plan_id: plan.id,
        start_date: DateTime.utc_now(),
        end_date: DateTime.utc_now() |> DateTime.add(90, :day),
        price: plan.price,
        house_id: house.id
      })
    end)
  end
end

BuddiesBackend.Repo.Seeds.Subscriptions.run()
