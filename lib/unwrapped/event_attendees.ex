defmodule Unwrapped.EventAttendees do
  @moduledoc """
  The Event Attendees context.
  """
  import Ecto.Query, warn: false
  alias Unwrapped.Repo
  alias Unwrapped.EventAttendees.EventAttendee

  def change_event_attendee(%EventAttendee{} = event_attendee, attrs \\ %{}) do
    EventAttendee.changeset(event_attendee, attrs)
  end

  def create_event_attendee(attrs) do
    %EventAttendee{}
    |> EventAttendee.changeset(attrs)
    |> Repo.insert()
  rescue
    Ecto.ConstraintError ->
      {:error, :already_signed_up}
  end

  def get_event_attendee!(id) do
    EventAttendee
    |> Repo.get!(id)
  end

  def get_event_attendee_with_event(id) do
    EventAttendee
    |> Repo.get!(id)
    |> Repo.preload([:event])
  end

  def get_event_attendee_with_event!(id) do
    EventAttendee
    |> Repo.get!(id)
    |> Repo.preload([:event])
  end
end
