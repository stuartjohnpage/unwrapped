defmodule Unwrapped.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    has_many :event_attendees, Unwrapped.EventAttendee
    has_many :users, through: [:event_attendees, :user]

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
