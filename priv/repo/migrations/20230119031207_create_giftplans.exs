defmodule Unwrapped.Repo.Migrations.CreateGiftplans do
  use Ecto.Migration

  def change do
    create table(:giftplans) do
      add :name, :string
      add :event_attendee_from, references(:event_attendees)
      add :event_attendee_to, references(:event_attendees)

      timestamps()
    end
  end
end
