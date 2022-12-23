defmodule Unwrapped.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string

    many_to_many(:users, Unwrapped.Accounts.User,
      join_through: "subscribed_events",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
