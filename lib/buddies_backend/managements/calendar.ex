defmodule BuddiesBackend.Managements.Calendar do
  use BuddiesBackend.Schema

  alias BuddiesBackend.Activities.Activity
  alias BuddiesBackend.Managements.Management

  @required_fields ~w(management_id)a



  schema "calendars" do
    belongs_to :management, Management
    has_many :activities, Activity

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(calendar, attrs) do
    calendar
    |> cast(attrs, @required_fields)
    |> validate_required([:management_id])
  end
end
