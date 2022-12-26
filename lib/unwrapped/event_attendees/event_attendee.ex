defmodule Unwrapped.EventAttendee do
  use Ecto.Schema

  schema "event_attendees" do
    belongs_to :event, Unwrapped.Events.Event
    belongs_to :user, Unwrapped.Accounts.User

    field :gift_plan, :string
  end
end
