defmodule BuddiesBackendWeb.ShoppingCartJSON do
  alias BuddiesBackend.Managements.ShoppingCart

  @doc """
  Renders a list of shoppingcarts.
  """
  def index(%{shoppingcarts: shoppingcarts}) do
    %{data: for(shopping_cart <- shoppingcarts, do: data(shopping_cart))}
  end

  @doc """
  Renders a single shopping_cart.
  """
  def show(%{shopping_cart: shopping_cart}) do
    %{data: data(shopping_cart)}
  end

  defp data(%ShoppingCart{} = shopping_cart) do
    %{
      id: shopping_cart.id
    }
  end
end
