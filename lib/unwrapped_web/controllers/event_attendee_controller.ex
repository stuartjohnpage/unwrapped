defmodule UnwrappedWeb.EventAttendee do
  alias Unwrapped.EventAttendees.EventAttendee
  alias Unwrapped.EventAttendees

  use UnwrappedWeb, :controller
  def new(conn, _params) do
    changeset = EventAttendees.change_event_attendee(%EventAttendee{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case Events.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
