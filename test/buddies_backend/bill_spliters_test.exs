defmodule BuddiesBackend.BillSplitersTest do
  use BuddiesBackend.DataCase

  alias BuddiesBackend.BillSpliters

  describe "billspliters" do
    alias BuddiesBackend.Managements.BillSpliter

    import BuddiesBackend.BillSplitersFixtures

    @invalid_attrs %{}

    test "list_billspliters/0 returns all billspliters" do
      bill_spliter = bill_spliter_fixture()
      assert BillSpliters.list_billspliters() == [bill_spliter]
    end

    test "get_bill_spliter!/1 returns the bill_spliter with given id" do
      bill_spliter = bill_spliter_fixture()
      assert BillSpliters.get_bill_spliter!(bill_spliter.id) == bill_spliter
    end

    test "create_bill_spliter/1 with valid data creates a bill_spliter" do
      valid_attrs = %{}

      assert {:ok, %BillSpliter{} = bill_spliter} = BillSpliters.create_bill_spliter(valid_attrs)
    end

    test "create_bill_spliter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BillSpliters.create_bill_spliter(@invalid_attrs)
    end

    test "update_bill_spliter/2 with valid data updates the bill_spliter" do
      bill_spliter = bill_spliter_fixture()
      update_attrs = %{}

      assert {:ok, %BillSpliter{} = bill_spliter} =
               BillSpliters.update_bill_spliter(bill_spliter, update_attrs)
    end

    test "update_bill_spliter/2 with invalid data returns error changeset" do
      bill_spliter = bill_spliter_fixture()

      assert {:error, %Ecto.Changeset{}} =
               BillSpliters.update_bill_spliter(bill_spliter, @invalid_attrs)

      assert bill_spliter == BillSpliters.get_bill_spliter!(bill_spliter.id)
    end

    test "delete_bill_spliter/1 deletes the bill_spliter" do
      bill_spliter = bill_spliter_fixture()
      assert {:ok, %BillSpliter{}} = BillSpliters.delete_bill_spliter(bill_spliter)
      assert_raise Ecto.NoResultsError, fn -> BillSpliters.get_bill_spliter!(bill_spliter.id) end
    end

    test "change_bill_spliter/1 returns a bill_spliter changeset" do
      bill_spliter = bill_spliter_fixture()
      assert %Ecto.Changeset{} = BillSpliters.change_bill_spliter(bill_spliter)
    end
  end
end
