defmodule Unwrapped.Repo.Migrations.CreateGiftplans do
  use Ecto.Migration

  def change do
    create table(:giftplans) do
      add :name, :string
      add :gift_from_id, references(:event_attendees)
      add :gift_to_id, references(:event_attendees)

      timestamps()
    end
  end
end
