defmodule BuddiesBackend.Repo.Seeds.Bills do
  @moduledoc """
  Script for populating the database with bills.
  You can run it as:
    $ mix run priv/repo/seeds/bills.exs
  """

  alias BuddiesBackend.Bills
  alias BuddiesBackend.BillSpliters

  def run do
    case Bills.list_bills() do
      [] ->
        seed_bills()

      _ ->
        Mix.shell().error("Found bills, aborting seeding bills.")
    end
  end

  def seed_bills do
    bill_spliters = BillSpliters.list_billspliters()
    for bill_spliter <- bill_spliters do
      for _ <- 1..10 do
        Bills.create_bill(
          %{
            "description" => "Jantar de Aniversário",
            "price" => Enum.random(10..100),
            "due_date" => DateTime.utc_now() |> DateTime.add(Enum.random(0..30), :day),
            "bill_spliter_id" => bill_spliter.id
          }
        )
      end
    end
  end
end

BuddiesBackend.Repo.Seeds.Bills.run()
