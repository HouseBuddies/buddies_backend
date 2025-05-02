defmodule BuddiesBackend.Managements.Calendar do
  use BuddiesBackend.Schema

  @required_fields ~w(management_id)a
  @optional_fields ~w()a

  schema "calendars" do
    belongs_to :management, BuddiesBackend.Managements.Management
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(calendar, attrs) do
    calendar
    |> cast(attrs, @required_fields)
    |> validate_required([:management_id])
  end
end
