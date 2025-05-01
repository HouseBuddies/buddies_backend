defmodule BuddiesBackendWeb.ErrorJSONTest do
  use BuddiesBackendWeb.ConnCase, async: true

  test "renders 404" do
    assert BuddiesBackendWeb.ErrorJSON.render("404.json", %{}) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 500" do
    assert BuddiesBackendWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
