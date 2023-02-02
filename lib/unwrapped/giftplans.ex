defmodule Unwrapped.Giftplans do
  @moduledoc """
  The Event Attendees context.
  """
  import Ecto.Query, warn: false
  alias Unwrapped.Repo
  alias Unwrapped.Giftplans.Giftplan

  def change_giftplan(%Giftplan{} = giftplan, attrs \\ %{}) do
    Giftplan.changeset(giftplan, attrs)
  end

  def delete_giftplan(%Giftplan{} = giftplan) do
    Repo.delete(giftplan)
  end

  def update_giftplan(%Giftplan{} = giftplan, attrs) do
    giftplan
    |> Giftplan.changeset(attrs)
    |> Repo.update()
  end

  def create_giftplan(attrs \\ %{}) do
    %Giftplan{}
    |> Giftplan.changeset(attrs)
    |> Repo.insert()
  end

  def get_giftplan!(id) do
    Giftplan
    |> Repo.get!(id)
  end

  def list_giftplans do
    Repo.all(Giftplan)
  end
end
