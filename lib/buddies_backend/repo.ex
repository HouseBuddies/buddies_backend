defmodule BuddiesBackend.Repo do
  use Ecto.Repo,
    otp_app: :buddies_backend,
    adapter: Ecto.Adapters.Postgres
end
