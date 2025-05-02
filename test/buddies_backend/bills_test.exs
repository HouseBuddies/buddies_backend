defmodule BuddiesBackend.BillsTest do
  use BuddiesBackend.DataCase

  alias BuddiesBackend.Bills

  describe "bills" do
    alias BuddiesBackend.Bills.Bill

    import BuddiesBackend.BillsFixtures

    @invalid_attrs %{price: nil, due_date: nil}

    test "list_bills/0 returns all bills" do
      bill = bill_fixture()
      assert Bills.list_bills() == [bill]
    end

    test "get_bill!/1 returns the bill with given id" do
      bill = bill_fixture()
      assert Bills.get_bill!(bill.id) == bill
    end

    test "create_bill/1 with valid data creates a bill" do
      valid_attrs = %{price: "120.5", due_date: ~U[2025-05-01 00:34:00Z]}

      assert {:ok, %Bill{} = bill} = Bills.create_bill(valid_attrs)
      assert bill.price == Decimal.new("120.5")
      assert bill.due_date == ~U[2025-05-01 00:34:00Z]
    end

    test "create_bill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bills.create_bill(@invalid_attrs)
    end

    test "update_bill/2 with valid data updates the bill" do
      bill = bill_fixture()
      update_attrs = %{price: "456.7", due_date: ~U[2025-05-02 00:34:00Z]}

      assert {:ok, %Bill{} = bill} = Bills.update_bill(bill, update_attrs)
      assert bill.price == Decimal.new("456.7")
      assert bill.due_date == ~U[2025-05-02 00:34:00Z]
    end

    test "update_bill/2 with invalid data returns error changeset" do
      bill = bill_fixture()
      assert {:error, %Ecto.Changeset{}} = Bills.update_bill(bill, @invalid_attrs)
      assert bill == Bills.get_bill!(bill.id)
    end

    test "delete_bill/1 deletes the bill" do
      bill = bill_fixture()
      assert {:ok, %Bill{}} = Bills.delete_bill(bill)
      assert_raise Ecto.NoResultsError, fn -> Bills.get_bill!(bill.id) end
    end

    test "change_bill/1 returns a bill changeset" do
      bill = bill_fixture()
      assert %Ecto.Changeset{} = Bills.change_bill(bill)
    end
  end
end
