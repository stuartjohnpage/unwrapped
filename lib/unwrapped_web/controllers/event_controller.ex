defmodule UnwrappedWeb.EventController do
  use UnwrappedWeb, :controller
  alias Unwrapped.Events
  alias Unwrapped.Events.Event
  alias Unwrapped.EventAttendees

  def index(%{assigns: %{current_user: current_user}} = conn, _params) do
    user_events = Events.list_user_events(current_user)
    render(conn, "index.html", user_events: user_events, current_user: current_user)
  end

  def new(conn, _params) do
    changeset = Events.change_event(%Event{})
    IO.inspect(changeset)

    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_user: current_user}} = conn, %{"event" => event_params}) do
    case Events.create_event(current_user, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%{assigns: %{current_user: current_user}} = conn, %{"id" => id}) do
    event = Events.get_event_with_attendees(id)
    event_attendees = event.event_attendees

    render(conn, "show.html",
      event: event,
      event_attendees: event_attendees,
      current_user: current_user
    )
  end

  def edit(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    changeset = Events.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)

    case Events.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    {:ok, _event} = Events.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end

  def sign_up(%{assigns: %{current_user: current_user}} = conn, %{"id" => id}) do
    case EventAttendees.create_event_attendee(%{"user_id" => current_user.id, "event_id" => id}) do
      {:ok, _} ->
        event = Events.get_event!(id)

        conn
        |> put_flash(:info, "Signed up to event successfully!")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, _} ->
        conn
        |> put_flash(:error, "Error")
        |> redirect(to: Routes.event_path(conn, :index))
    end
  end

  def join_by_invite_code(%{assigns: %{current_user: current_user}} = conn, %{
        "event" => %{"invite_code" => invite_code}
      }) do
    event = Events.get_event_by_invite_code(invite_code)

    case EventAttendees.create_event_attendee(%{
           "user_id" => current_user.id,
           "event_id" => event.id
         }) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Joined event successfully!")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, _} ->
        conn
        |> put_flash(:error, "Error")
        |> redirect(to: Routes.event_path(conn, :index))
    end
  end
end
