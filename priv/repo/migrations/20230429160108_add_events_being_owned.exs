defmodule Unwrapped.Repo.Migrations.AddEventsBeingOwned do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :owner_id, references(:users, on_delete: :nothing), null: true
    end

    create index(:events, [:owner_id])
  end
end
