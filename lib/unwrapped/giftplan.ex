defmodule Unwrapped.Giftplan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "giftplans" do
    field :name, :string
    belongs_to :event_attendee_to, Unwrapped.EventAttendee, foreign_key: :event_attendee_to_id
    belongs_to :event_attendee_from, Unwrapped.EventAttendee, foreign_key: :event_attendee_from_id

    timestamps()
  end

  @doc false
  def changeset(giftplan, attrs) do
    giftplan
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
