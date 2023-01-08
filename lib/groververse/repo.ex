defmodule Groververse.Repo do
  use Ecto.Repo,
    otp_app: :groververse,
    adapter: Ecto.Adapters.Postgres
end
