defmodule BuddiesBackendWeb.PlanJSON do
  alias BuddiesBackend.Plans.Plan

  @doc """
  Renders a list of plans.
  """
  def index(%{plans: plans}) do
    %{data: for(plan <- plans, do: data(plan))}
  end

  @doc """
  Renders a single plan.
  """
  def show(%{plan: plan}) do
    %{data: data(plan)}
  end

  defp data(%Plan{} = plan) do
    %{
      id: plan.id,
      name: plan.name,
      description: plan.description,
      price: plan.price
    }
  end
end
