defmodule BuddiesBackendWeb.BillSpliterJSON do
  alias BuddiesBackend.Managements.BillSpliter

  @doc """
  Renders a list of billspliters.
  """
  def index(%{billspliters: billspliters}) do
    %{data: for(bill_spliter <- billspliters, do: data(bill_spliter))}
  end

  @doc """
  Renders a single bill_spliter.
  """
  def show(%{bill_spliter: bill_spliter}) do
    %{data: data(bill_spliter)}
  end

  defp data(%BillSpliter{} = bill_spliter) do
    %{
      id: bill_spliter.id
    }
  end
end
