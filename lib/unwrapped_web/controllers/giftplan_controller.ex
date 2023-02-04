defmodule UnwrappedWeb.GiftplanController do
  use UnwrappedWeb, :controller
  alias Unwrapped.EventAttendees
  alias Unwrapped.Accounts
  alias Unwrapped.Giftplans
  alias Unwrapped.Giftplans.Giftplan
  alias Unwrapped.EventAttendees

  def index(conn, _params) do
    giftplans = Giftplans.list_giftplans()
    render(conn, "index.html", giftplans: giftplans)
  end

  def new(%{assigns: %{current_user: current_user}} = conn, %{"event" => id, "event_attendee" => event_attendee}) do

    user = Accounts.get_user_and_event_attendees(current_user.id)
    gift_receiver = EventAttendees.get_event_attendee!(event_attendee)
    gift_giver = user.event_attendees
    |> Enum.find(fn attendee ->
      attendee.event_id == String.to_integer(id)
    end)

    gift_receiver_user = Accounts.get_user!(gift_receiver.user_id)
    changeset = Giftplans.change_giftplan(%Giftplan{gift_to_id: gift_receiver.id, gift_from_id: gift_giver.id})
    render(conn, "new.html", changeset: changeset, gift_receiver: gift_receiver_user.first_name, gift_giver: current_user.first_name)
  end

  def create(conn, %{"giftplan" => giftplan_params}) do
    case Giftplans.create_giftplan(giftplan_params) do
      {:ok, giftplan} ->
        IO.inspect(giftplan)
        conn
        |> put_flash(:info, "Giftplan created successfully.")
        |> redirect(to: Routes.giftplan_path(conn, :show, giftplan))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    giftplan = Giftplans.get_giftplan!(id)
    render(conn, "show.html", giftplan: giftplan)
  end

  def edit(conn, %{"id" => id}) do
    giftplan = Giftplans.get_giftplan!(id)
    changeset = Giftplans.change_giftplan(giftplan)
    render(conn, "edit.html", giftplan: giftplan, changeset: changeset)
  end

  def update(conn, %{"id" => id, "giftplan" => giftplan_params}) do
    giftplan = Giftplans.get_giftplan!(id)

    case Giftplans.update_giftplan(giftplan, giftplan_params) do
      {:ok, giftplan} ->
        conn
        |> put_flash(:info, "Giftplan updated successfully.")
        |> redirect(to: Routes.giftplan_path(conn, :show, giftplan))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", giftplan: giftplan, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    giftplan = Giftplans.get_giftplan!(id)
    {:ok, _giftplan} = Giftplans.delete_giftplan(giftplan)

    conn
    |> put_flash(:info, "Giftplan deleted successfully.")
    |> redirect(to: Routes.giftplan_path(conn, :index))
  end
end
