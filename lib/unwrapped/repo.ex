defmodule Unwrapped.Repo do
  use Ecto.Repo,
    otp_app: :unwrapped,
    adapter: Ecto.Adapters.Postgres
end
