defmodule BuddiesBackend.Managements.BillSpliter do
  use BuddiesBackend.Schema

  @required_fields ~w(management_id)a
  @optional_fields ~w()

  schema "billspliters" do
    belongs_to :management, BuddiesBackend.Managements.Management
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bill_spliter, attrs) do
    bill_spliter
    |> cast(attrs, @required_fields)
    |> validate_required([:management_id])
  end
end
