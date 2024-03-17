defmodule ConferenceTranslator.Repo do
  use Ecto.Repo,
    otp_app: :conference_translator,
    adapter: Ecto.Adapters.Postgres
end
