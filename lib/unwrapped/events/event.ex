defmodule Unwrapped.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string

    belongs_to :owner, Unwrapped.Accounts.User
    has_many :event_attendees, Unwrapped.EventAttendees.EventAttendee
    has_many :users, through: [:event_attendees, :user]

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name])
    |> cast_assoc(:owner)
    |> validate_required([:name])
  end
end
