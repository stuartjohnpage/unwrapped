defmodule Unwrapped.Giftplan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "giftplans" do
    field :name, :string
    belongs_to :gift_from, Unwrapped.EventAttendee
    belongs_to :gift_to, Unwrapped.EventAttendee

    timestamps()
  end

  @doc false
  def changeset(giftplan, attrs) do
    giftplan
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
