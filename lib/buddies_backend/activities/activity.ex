defmodule BuddiesBackend.Activities.Activity do

  use BuddiesBackend.Schema
  alias BuddiesBackend.Accounts.User
  alias BuddiesBackend.Managements.Calendar

  @required_fields ~w(start_date end_date title created_by_id calendar_id)a
  @optional_fields ~w(description)a

  schema "activities" do
    belongs_to :calendar, Calendar
    belongs_to :created_by, User

    field :title, :string
    field :description, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime

    has_many :assigned_users, User


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
