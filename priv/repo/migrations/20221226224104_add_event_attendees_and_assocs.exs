defmodule Unwrapped.Repo.Migrations.AddEventAttendeesAndAssocs do
  use Ecto.Migration

  def change do
    create table(:event_attendees) do
      add :event_id, references(:events)
      add :user_id, references(:users)
      add :gift_plan, :string

      timestamps()
    end

    create index(:event_attendees, [:event_id])
    create unique_index(:event_attendees, [:user_id])
  end
end
