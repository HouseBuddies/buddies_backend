defmodule BuddiesBackendWeb.ProductJSON do
  alias BuddiesBackend.Products.Product

  @doc """
  Renders a list of products.
  """
  def index(%{products: products}) do
    %{data: for(product <- products, do: data(product))}
  end

  @doc """
  Renders a single product.
  """
  def show(%{product: product}) do
    %{data: data(product)}
  end

  defp data(%Product{state: :available} = product) do
    %{
      id: product.id,
      quantity: product.quantity,
      name: product.name,
      state: product.state,
      created_at: product.inserted_at,
      created_by: %{
        id: product.created_by.id,
        name: product.created_by.name,
        email: product.created_by.email,
        photo: product.created_by.photo
      }
    }
  end

  defp data(%Product{state: :purchased} = product) do
    %{
      id: product.id,
      quantity: product.quantity,
      name: product.name,
      state: product.state,
      created_by: %{
        id: product.created_by.id,
        name: product.created_by.name,
        email: product.created_by.email,
        photo: product.created_by.photo
      },
      purchased_by: %{
        id: product.purchased_by.id,
        name: product.purchased_by.name,
        email: product.purchased_by.email,
        photo: product.purchased_by.photo
      }
    }
  end
end
