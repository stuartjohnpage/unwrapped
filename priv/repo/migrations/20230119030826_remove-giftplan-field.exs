defmodule :"Elixir.Unwrapped.Repo.Migrations.Remove-giftplan-field" do
  use Ecto.Migration

  def change do
    alter table(:event_attendees) do
      remove :gift_plan
    end
  end
end
