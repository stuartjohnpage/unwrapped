defmodule Unwrapped.Repo.Migrations.CreateGiftIdeas do
  use Ecto.Migration

  def change do
    create table(:gift_ideas) do
      add :idea, :string
      add :giver_id, references(:users, on_delete: :nothing)
      add :recipient_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:gift_ideas, [:giver_id])
    create index(:gift_ideas, [:recipient_id])
  end
end
