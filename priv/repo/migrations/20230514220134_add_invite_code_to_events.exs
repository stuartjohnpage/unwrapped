defmodule Unwrapped.Repo.Migrations.AddInviteCodeToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :invite_code, :string
    end

    create unique_index(:events, [:invite_code])
  end
end
