defmodule Unwrapped.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :invite_code, :string

    belongs_to :owner, Unwrapped.Accounts.User
    has_many :event_attendees, Unwrapped.EventAttendees.EventAttendee
    has_many :users, through: [:event_attendees, :user]

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :invite_code])
    |> validate_required([:name, :invite_code])
    # or whatever length you deem necessary
    |> validate_length(:invite_code, min: 10)
    |> unique_constraint(:invite_code)
  end
end
