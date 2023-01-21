defmodule Unwrapped.EventAttendees do
  @moduledoc """
  The Event Attendees context.
  """
  alias Unwrapped.EventAttendees.EventAttendee

  def change_event_attendee(%EventAttendee{} = event_attendee, attrs \\ %{}) do
    EventAttendee.changeset(event_attendee, attrs)
  end
end
