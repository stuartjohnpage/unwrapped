defmodule Unwrapped.Repo.Migrations.AddSubscribeEventTable do
  use Ecto.Migration

  def change do
    create table(:subscribed_events) do
      add(:user_id, references(:users))
      add(:event_id, references(:events))
    end
  end
end
