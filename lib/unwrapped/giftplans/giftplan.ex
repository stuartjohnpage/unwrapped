defmodule Unwrapped.Giftplans.Giftplan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "giftplans" do
    field :name, :string
    belongs_to :gift_from, Unwrapped.EventAttendees.EventAttendee
    belongs_to :gift_to, Unwrapped.EventAttendees.EventAttendee

    timestamps()
  end

  @doc false
  def changeset(giftplan, attrs) do
    giftplan
    |> cast(attrs, [:name, :gift_to_id, :gift_from_id])
    |> validate_required([:name, :gift_to_id, :gift_from_id])
  end
end
