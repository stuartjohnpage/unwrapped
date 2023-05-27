defmodule Unwrapped.GiftIdeasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Unwrapped.GiftIdeas` context.
  """

  @doc """
  Generate a gift_idea.
  """
  def gift_idea_fixture(attrs \\ %{}) do
    {:ok, gift_idea} =
      attrs
      |> Enum.into(%{
        idea: "some idea"
      })
      |> Unwrapped.GiftIdeas.create_gift_idea()

    gift_idea
  end
end
