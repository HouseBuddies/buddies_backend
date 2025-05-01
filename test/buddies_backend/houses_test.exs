defmodule BuddiesBackend.HousesTest do
  use BuddiesBackend.DataCase

  alias BuddiesBackend.Houses

  describe "houses" do
    alias BuddiesBackend.Houses.House

    import BuddiesBackend.HousesFixtures

    @invalid_attrs %{rent: nil, rooms: nil, available_date: nil}

    test "list_houses/0 returns all houses" do
      house = house_fixture()
      assert Houses.list_houses() == [house]
    end

    test "get_house!/1 returns the house with given id" do
      house = house_fixture()
      assert Houses.get_house!(house.id) == house
    end

    test "create_house/1 with valid data creates a house" do
      valid_attrs = %{rent: "120.5", rooms: 42, available_date: ~U[2025-04-30 19:57:00Z]}

      assert {:ok, %House{} = house} = Houses.create_house(valid_attrs)
      assert house.rent == Decimal.new("120.5")
      assert house.rooms == 42
      assert house.available_date == ~U[2025-04-30 19:57:00Z]
    end

    test "create_house/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Houses.create_house(@invalid_attrs)
    end

    test "update_house/2 with valid data updates the house" do
      house = house_fixture()
      update_attrs = %{rent: "456.7", rooms: 43, available_date: ~U[2025-05-01 19:57:00Z]}

      assert {:ok, %House{} = house} = Houses.update_house(house, update_attrs)
      assert house.rent == Decimal.new("456.7")
      assert house.rooms == 43
      assert house.available_date == ~U[2025-05-01 19:57:00Z]
    end

    test "update_house/2 with invalid data returns error changeset" do
      house = house_fixture()
      assert {:error, %Ecto.Changeset{}} = Houses.update_house(house, @invalid_attrs)
      assert house == Houses.get_house!(house.id)
    end

    test "delete_house/1 deletes the house" do
      house = house_fixture()
      assert {:ok, %House{}} = Houses.delete_house(house)
      assert_raise Ecto.NoResultsError, fn -> Houses.get_house!(house.id) end
    end

    test "change_house/1 returns a house changeset" do
      house = house_fixture()
      assert %Ecto.Changeset{} = Houses.change_house(house)
    end
  end

  describe "user_houses" do
    alias BuddiesBackend.Houses.UserHouse

    import BuddiesBackend.HousesFixtures

    @invalid_attrs %{}

    test "list_user_houses/0 returns all user_houses" do
      user_house = user_house_fixture()
      assert Houses.list_user_houses() == [user_house]
    end

    test "get_user_house!/1 returns the user_house with given id" do
      user_house = user_house_fixture()
      assert Houses.get_user_house!(user_house.id) == user_house
    end

    test "create_user_house/1 with valid data creates a user_house" do
      valid_attrs = %{}

      assert {:ok, %UserHouse{} = user_house} = Houses.create_user_house(valid_attrs)
    end

    test "create_user_house/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Houses.create_user_house(@invalid_attrs)
    end

    test "update_user_house/2 with valid data updates the user_house" do
      user_house = user_house_fixture()
      update_attrs = %{}

      assert {:ok, %UserHouse{} = user_house} = Houses.update_user_house(user_house, update_attrs)
    end

    test "update_user_house/2 with invalid data returns error changeset" do
      user_house = user_house_fixture()
      assert {:error, %Ecto.Changeset{}} = Houses.update_user_house(user_house, @invalid_attrs)
      assert user_house == Houses.get_user_house!(user_house.id)
    end

    test "delete_user_house/1 deletes the user_house" do
      user_house = user_house_fixture()
      assert {:ok, %UserHouse{}} = Houses.delete_user_house(user_house)
      assert_raise Ecto.NoResultsError, fn -> Houses.get_user_house!(user_house.id) end
    end

    test "change_user_house/1 returns a user_house changeset" do
      user_house = user_house_fixture()
      assert %Ecto.Changeset{} = Houses.change_user_house(user_house)
    end
  end
end
