defmodule BuddiesBackend.Managements.Calendar do
  use BuddiesBackend.Schema

  @required_fields ~w()
  @optional_fields ~w()

  schema "calendars" do
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(calendar, attrs) do
    calendar
    |> cast(attrs, [])
    |> validate_required([])
  end
end
