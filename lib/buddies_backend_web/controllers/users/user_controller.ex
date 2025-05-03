defmodule BuddiesBackendWeb.UserController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Accounts
  alias BuddiesBackend.Accounts.User
  alias BuddiesBackend.Repo

  def create(conn, user_params) do
    %{"name" => name, "email" => email, "password" => password} = user_params

    case User.registration_changeset(%User{}, user_params) |> Repo.insert() do
      {:ok, user} ->
        token = Accounts.create_user_api_token(user)

        body =
          %{
            user: %{
              id: user.id,
              email: user.email,
              token: token
            }
          }
          |> Jason.encode!()

        conn
        |> put_resp_content_type("application/json")
        |> put_resp_header("authorization", "Bearer #{token}")
        |> send_resp(200, body)

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: changeset_error_to_string(changeset)}))
    end
  end

  def show(conn, _params) do
    user = conn.assigns[:current_user]

    body =
      %{
        user: %{
          id: user.id,
          name: user.name,
          age: user.age,
          email: user.email,
          photo: user.photo,
          location: user.location || "",
          first_time_login: user.first_time_login
        }
      }
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end

  def update_preferences(conn, params) do
    user = conn.assigns[:current_user]

    # Update first login to false.
    Accounts.update_user_first_login(user)

    case User.preferences_changeset(user, params) |> Repo.update() do
      {:ok, _user} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, "")

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: changeset_error_to_string(changeset)}))
    end
  end
end
