defmodule BuddiesBackend.ShoppingCarts do
  @moduledoc """
  The ShoppingCarts context.
  """

  import Ecto.Query, warn: false
  alias BuddiesBackend.Repo

  alias BuddiesBackend.Managements.ShoppingCart

  @doc """
  Returns the list of shoppingcarts.

  ## Examples

      iex> list_shoppingcarts()
      [%ShoppingCart{}, ...]

  """
  def list_shoppingcarts do
    Repo.all(ShoppingCart)
  end

  @doc """
  Gets a single shopping_cart.

  Raises `Ecto.NoResultsError` if the Shopping cart does not exist.

  ## Examples

      iex> get_shopping_cart!(123)
      %ShoppingCart{}

      iex> get_shopping_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shopping_cart!(id), do: Repo.get!(ShoppingCart, id)

  @doc """
  Creates a shopping_cart.

  ## Examples

      iex> create_shopping_cart(%{field: value})
      {:ok, %ShoppingCart{}}

      iex> create_shopping_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shopping_cart(attrs \\ %{}) do
    %ShoppingCart{}
    |> ShoppingCart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shopping_cart.

  ## Examples

      iex> update_shopping_cart(shopping_cart, %{field: new_value})
      {:ok, %ShoppingCart{}}

      iex> update_shopping_cart(shopping_cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shopping_cart(%ShoppingCart{} = shopping_cart, attrs) do
    shopping_cart
    |> ShoppingCart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shopping_cart.

  ## Examples

      iex> delete_shopping_cart(shopping_cart)
      {:ok, %ShoppingCart{}}

      iex> delete_shopping_cart(shopping_cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shopping_cart(%ShoppingCart{} = shopping_cart) do
    Repo.delete(shopping_cart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shopping_cart changes.

  ## Examples

      iex> change_shopping_cart(shopping_cart)
      %Ecto.Changeset{data: %ShoppingCart{}}

  """
  def change_shopping_cart(%ShoppingCart{} = shopping_cart, attrs \\ %{}) do
    ShoppingCart.changeset(shopping_cart, attrs)
  end
end
