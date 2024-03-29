defmodule Unwrapped.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Unwrapped.Repo
  alias Unwrapped.Accounts.User
  alias Unwrapped.Events.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id) do
    Event
    |> Repo.get!(id)
    |> Repo.preload([:users])
  end

  def get_event_with_attendees(id) do
    Event
    |> Repo.get(id)
    |> Repo.preload([:users, event_attendees: [event_attendee_from: [gift_to: [:user]]]])
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(%User{} = user, attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:owner, user)
    |> Repo.insert()
    |> IO.inspect()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def get_event_by_invite_code(invite_code) do
    Event
    |> where(invite_code: ^invite_code)
    |> Repo.one()
  end

  @doc """
  Fetches all events for a given user.

  ## Params:

  - `user`: A User struct, must contain `id`.

  ## Returns:

  - List of Event structs associated with the user.

  """

  def list_user_events(user) do
    from(e in Event,
      join: ea in assoc(e, :event_attendees),
      where: ea.user_id == ^user.id,
      select: e
    )
    |> Repo.all()
  end
end
