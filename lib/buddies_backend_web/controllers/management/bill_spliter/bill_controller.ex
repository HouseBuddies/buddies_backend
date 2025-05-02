defmodule BuddiesBackendWeb.BillController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Bills
  alias BuddiesBackend.Bills.Bill

  action_fallback BuddiesBackendWeb.FallbackController

  def index(conn, _params) do
    bills = Bills.list_bills()
    render(conn, :index, bills: bills)
  end

  def create(conn, %{"bill" => bill_params}) do
    with {:ok, %Bill{} = bill} <- Bills.create_bill(bill_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/bills/#{bill}")
      |> render(:show, bill: bill)
    end
  end

  def show(conn, %{"id" => id}) do
    bill = Bills.get_bill!(id)
    render(conn, :show, bill: bill)
  end

  def update(conn, %{"id" => id, "bill" => bill_params}) do
    bill = Bills.get_bill!(id)

    with {:ok, %Bill{} = bill} <- Bills.update_bill(bill, bill_params) do
      render(conn, :show, bill: bill)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill = Bills.get_bill!(id)

    with {:ok, %Bill{}} <- Bills.delete_bill(bill) do
      send_resp(conn, :no_content, "")
    end
  end
end
