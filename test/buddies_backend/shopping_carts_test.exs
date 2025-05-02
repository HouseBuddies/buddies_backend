defmodule BuddiesBackend.ShoppingCartsTest do
  use BuddiesBackend.DataCase

  alias BuddiesBackend.ShoppingCarts

  describe "shoppingcarts" do
    alias BuddiesBackend.Managements.ShoppingCart

    import BuddiesBackend.ShoppingCartsFixtures

    @invalid_attrs %{}

    test "list_shoppingcarts/0 returns all shoppingcarts" do
      shopping_cart = shopping_cart_fixture()
      assert ShoppingCarts.list_shoppingcarts() == [shopping_cart]
    end

    test "get_shopping_cart!/1 returns the shopping_cart with given id" do
      shopping_cart = shopping_cart_fixture()
      assert ShoppingCarts.get_shopping_cart!(shopping_cart.id) == shopping_cart
    end

    test "create_shopping_cart/1 with valid data creates a shopping_cart" do
      valid_attrs = %{}

      assert {:ok, %ShoppingCart{} = shopping_cart} = ShoppingCarts.create_shopping_cart(valid_attrs)
    end

    test "create_shopping_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCarts.create_shopping_cart(@invalid_attrs)
    end

    test "update_shopping_cart/2 with valid data updates the shopping_cart" do
      shopping_cart = shopping_cart_fixture()
      update_attrs = %{}

      assert {:ok, %ShoppingCart{} = shopping_cart} = ShoppingCarts.update_shopping_cart(shopping_cart, update_attrs)
    end

    test "update_shopping_cart/2 with invalid data returns error changeset" do
      shopping_cart = shopping_cart_fixture()
      assert {:error, %Ecto.Changeset{}} = ShoppingCarts.update_shopping_cart(shopping_cart, @invalid_attrs)
      assert shopping_cart == ShoppingCarts.get_shopping_cart!(shopping_cart.id)
    end

    test "delete_shopping_cart/1 deletes the shopping_cart" do
      shopping_cart = shopping_cart_fixture()
      assert {:ok, %ShoppingCart{}} = ShoppingCarts.delete_shopping_cart(shopping_cart)
      assert_raise Ecto.NoResultsError, fn -> ShoppingCarts.get_shopping_cart!(shopping_cart.id) end
    end

    test "change_shopping_cart/1 returns a shopping_cart changeset" do
      shopping_cart = shopping_cart_fixture()
      assert %Ecto.Changeset{} = ShoppingCarts.change_shopping_cart(shopping_cart)
    end
  end
end
