defmodule Unwrapped.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Unwrapped.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Unwrapped.Events.create_event()

    event
  end
end
