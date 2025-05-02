defmodule BuddiesBackend.Managements.BillSpliter do
  use BuddiesBackend.Schema

  @required_fields ~w()
  @optional_fields ~w()

  schema "billspliters" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bill_spliter, attrs) do
    bill_spliter
    |> cast(attrs, [])
    |> validate_required([])
  end
end
