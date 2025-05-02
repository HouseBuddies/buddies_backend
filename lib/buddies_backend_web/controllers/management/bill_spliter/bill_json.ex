defmodule BuddiesBackendWeb.BillJSON do
  alias BuddiesBackend.Bills.Bill

  @doc """
  Renders a list of bills.
  """
  def index(%{bills: bills}) do
    %{data: for(bill <- bills, do: data(bill))}
  end

  @doc """
  Renders a single bill.
  """
  def show(%{bill: bill}) do
    %{data: data(bill)}
  end

  defp data(%Bill{} = bill) do
    %{
      id: bill.id,
      description: bill.description,
      price: bill.price,
      due_date: bill.due_date
    }
  end
end
