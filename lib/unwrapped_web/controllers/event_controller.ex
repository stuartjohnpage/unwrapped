defmodule UnwrappedWeb.EventController do
  use UnwrappedWeb, :controller
  alias Unwrapped.Accounts
  alias Unwrapped.Events
  alias Unwrapped.Events.Event
  alias Unwrapped.EventAttendees

  def index(%{assigns: %{current_user: current_user}} = conn, _params) do
    events = Events.list_events()
    render(conn, "index.html", events: events, current_user: current_user)
  end

  def new(conn, _params) do
    changeset = Events.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    IO.inspect(event_params)
    # %{"name" => "Katherine's Birthday"}
    case Events.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%{assigns: %{current_user: current_user}} = conn, %{"id" => id}) do
    event = Events.get_event_with_attendees!(id)
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
    EventAttendees.create_event_attendee(%{"user_id" => current_user.id, "event_id" => id})

    conn
    |> redirect(to: Routes.event_path(conn, :index))
  end

  def create_gift_plan(%{assigns: %{current_user: current_user}} = conn, %{"id" => id}) do
    user = Accounts.get_user_and_event_attendees(current_user.id)

    user.event_attendees
    |> Enum.find(fn attendee ->
      attendee.event_id == String.to_integer(id)
    end)
    |> IO.inspect()

    conn
    |> redirect(to: Routes.event_path(conn, :index))
  end
end
