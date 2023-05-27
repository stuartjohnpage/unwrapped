defmodule Unwrapped.GiftIdeas.GiftIdea do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gift_ideas" do
    field :idea, :string
    belongs_to :giver, Unwrapped.Accounts.User, foreign_key: :giver_id
    belongs_to :recipient, Unwrapped.Accounts.User, foreign_key: :recipient_id
    timestamps()
  end

  def changeset(gift_idea, attrs) do
    gift_idea
    |> cast(attrs, [:idea])
    |> validate_required([:idea])
  end
end
