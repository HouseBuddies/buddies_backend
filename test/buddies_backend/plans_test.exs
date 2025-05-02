defmodule BuddiesBackend.PlansTest do
  use BuddiesBackend.DataCase

  alias BuddiesBackend.Plans

  describe "plans" do
    alias BuddiesBackend.Plans.Plan

    import BuddiesBackend.PlansFixtures

    @invalid_attrs %{name: nil, description: nil, price: nil}

    test "list_plans/0 returns all plans" do
      plan = plan_fixture()
      assert Plans.list_plans() == [plan]
    end

    test "get_plan!/1 returns the plan with given id" do
      plan = plan_fixture()
      assert Plans.get_plan!(plan.id) == plan
    end

    test "create_plan/1 with valid data creates a plan" do
      valid_attrs = %{name: "some name", description: "some description", price: "120.5"}

      assert {:ok, %Plan{} = plan} = Plans.create_plan(valid_attrs)
      assert plan.name == "some name"
      assert plan.description == "some description"
      assert plan.price == Decimal.new("120.5")
    end

    test "create_plan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Plans.create_plan(@invalid_attrs)
    end

    test "update_plan/2 with valid data updates the plan" do
      plan = plan_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        price: "456.7"
      }

      assert {:ok, %Plan{} = plan} = Plans.update_plan(plan, update_attrs)
      assert plan.name == "some updated name"
      assert plan.description == "some updated description"
      assert plan.price == Decimal.new("456.7")
    end

    test "update_plan/2 with invalid data returns error changeset" do
      plan = plan_fixture()
      assert {:error, %Ecto.Changeset{}} = Plans.update_plan(plan, @invalid_attrs)
      assert plan == Plans.get_plan!(plan.id)
    end

    test "delete_plan/1 deletes the plan" do
      plan = plan_fixture()
      assert {:ok, %Plan{}} = Plans.delete_plan(plan)
      assert_raise Ecto.NoResultsError, fn -> Plans.get_plan!(plan.id) end
    end

    test "change_plan/1 returns a plan changeset" do
      plan = plan_fixture()
      assert %Ecto.Changeset{} = Plans.change_plan(plan)
    end
  end
end
