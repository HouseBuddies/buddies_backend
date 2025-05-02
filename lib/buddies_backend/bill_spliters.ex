defmodule BuddiesBackend.BillSpliters do
  @moduledoc """
  The BillSpliters context.
  """

  import Ecto.Query, warn: false
  alias BuddiesBackend.Repo

  alias BuddiesBackend.Managements.BillSpliter

  @doc """
  Returns the list of billspliters.

  ## Examples

      iex> list_billspliters()
      [%BillSpliter{}, ...]

  """
  def list_billspliters do
    Repo.all(BillSpliter)
  end

  @doc """
  Gets a single bill_spliter.

  Raises `Ecto.NoResultsError` if the Bill spliter does not exist.

  ## Examples

      iex> get_bill_spliter!(123)
      %BillSpliter{}

      iex> get_bill_spliter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bill_spliter!(id), do: Repo.get!(BillSpliter, id)

  @doc """
  Creates a bill_spliter.

  ## Examples

      iex> create_bill_spliter(%{field: value})
      {:ok, %BillSpliter{}}

      iex> create_bill_spliter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bill_spliter(attrs \\ %{}) do
    %BillSpliter{}
    |> BillSpliter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bill_spliter.

  ## Examples

      iex> update_bill_spliter(bill_spliter, %{field: new_value})
      {:ok, %BillSpliter{}}

      iex> update_bill_spliter(bill_spliter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bill_spliter(%BillSpliter{} = bill_spliter, attrs) do
    bill_spliter
    |> BillSpliter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bill_spliter.

  ## Examples

      iex> delete_bill_spliter(bill_spliter)
      {:ok, %BillSpliter{}}

      iex> delete_bill_spliter(bill_spliter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bill_spliter(%BillSpliter{} = bill_spliter) do
    Repo.delete(bill_spliter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bill_spliter changes.

  ## Examples

      iex> change_bill_spliter(bill_spliter)
      %Ecto.Changeset{data: %BillSpliter{}}

  """
  def change_bill_spliter(%BillSpliter{} = bill_spliter, attrs \\ %{}) do
    BillSpliter.changeset(bill_spliter, attrs)
  end
end
