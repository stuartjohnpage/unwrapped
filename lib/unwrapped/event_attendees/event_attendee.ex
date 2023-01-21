defmodule Unwrapped.EventAttendees.EventAttendee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event_attendees" do
    belongs_to :event, Unwrapped.Events.Event
    belongs_to :user, Unwrapped.Accounts.User

    has_many :event_attendee_from, Unwrapped.Giftplan, foreign_key: :gift_from_id
    has_many :event_attendee_to, Unwrapped.Giftplan, foreign_key: :gift_to_id

  end

  def changeset(event_attendee, attrs) do
    event_attendee
    |> cast(attrs, [:event_id, :user_id])
  end
end
