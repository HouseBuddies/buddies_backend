defmodule BuddiesBackend.SubscriptionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuddiesBackend.Subscriptions` context.
  """

  @doc """
  Generate a subscription.
  """
  def subscription_fixture(attrs \\ %{}) do
    {:ok, subscription} =
      attrs
      |> Enum.into(%{

      })
      |> BuddiesBackend.Subscriptions.create_subscription()

    subscription
  end
end
