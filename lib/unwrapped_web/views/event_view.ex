defmodule UnwrappedWeb.EventView do
  use UnwrappedWeb, :view

  def user_signed_up(user, event_attendees) do
    event_attendees
    |> Enum.find(false, fn attendee ->
      attendee.user_id == user.id
    end)
  end
end
