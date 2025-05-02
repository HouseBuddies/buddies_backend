defmodule BuddiesBackendWeb.UserSessionController do
  use BuddiesBackendWeb, :controller

  alias BuddiesBackend.Accounts

  def create(conn, user_params) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      token = Accounts.create_user_api_token(user)

      body =
        %{
          user: %{
            id: user.id,
            email: user.email,
            token: token,
            first_time_login: user.first_time_login,
          }
        }
        |> Jason.encode!()

      conn
      |> put_resp_content_type("application/json")
      |> put_resp_header("authorization", "Bearer #{token}")
      |> send_resp(200, body)
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, Jason.encode!(%{error: "invalid email or password"}))
      |> halt()
    end
  end

  def delete(conn, _params) do
    user = conn.assigns[:current_user]

    Accounts.delete_user_api_token(user)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{message: "logged out successfully"}))
  end
end
