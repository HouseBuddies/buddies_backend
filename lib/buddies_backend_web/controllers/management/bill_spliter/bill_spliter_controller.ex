defmodule BuddiesBackendWeb.BillSpliterController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.BillSpliters
  alias BuddiesBackend.Managements.BillSpliter

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, _params) do
    billspliters = BillSpliters.list_billspliters()
    render(conn, :index, billspliters: billspliters)
  end

  def create(conn, %{"bill_spliter" => bill_spliter_params}) do
    with {:ok, %BillSpliter{} = bill_spliter} <- BillSpliters.create_bill_spliter(bill_spliter_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/billspliters/#{bill_spliter}")
      |> render(:show, bill_spliter: bill_spliter)
    end
  end

  def show(conn, %{"id" => id}) do
    bill_spliter = BillSpliters.get_bill_spliter!(id)
    render(conn, :show, bill_spliter: bill_spliter)
  end

  def update(conn, %{"id" => id, "bill_spliter" => bill_spliter_params}) do
    bill_spliter = BillSpliters.get_bill_spliter!(id)

    with {:ok, %BillSpliter{} = bill_spliter} <- BillSpliters.update_bill_spliter(bill_spliter, bill_spliter_params) do
      render(conn, :show, bill_spliter: bill_spliter)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill_spliter = BillSpliters.get_bill_spliter!(id)

    with {:ok, %BillSpliter{}} <- BillSpliters.delete_bill_spliter(bill_spliter) do
      send_resp(conn, :no_content, "")
    end
  end
end
