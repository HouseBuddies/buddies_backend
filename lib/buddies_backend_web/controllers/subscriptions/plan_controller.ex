defmodule BuddiesBackendWeb.PlanController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Plans
  alias BuddiesBackend.Plans.Plan

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, _params) do
    plans = Plans.list_plans()
    render(conn, :index, plans: plans)
  end

  def create(conn, %{"plan" => plan_params}) do
    with {:ok, %Plan{} = plan} <- Plans.create_plan(plan_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/plans/#{plan}")
      |> render(:show, plan: plan)
    end
  end

  def show(conn, %{"name" => name}) do
    plan = Plans.get_plan_by_name!(name)
    render(conn, :show, plan: plan)
  end

  def update(conn, %{"id" => id, "plan" => plan_params}) do
    plan = Plans.get_plan!(id)

    with {:ok, %Plan{} = plan} <- Plans.update_plan(plan, plan_params) do
      render(conn, :show, plan: plan)
    end
  end

  def delete(conn, %{"id" => id}) do
    plan = Plans.get_plan!(id)

    with {:ok, %Plan{}} <- Plans.delete_plan(plan) do
      send_resp(conn, :no_content, "")
    end
  end
end
