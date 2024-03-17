defmodule ConferenceTranslator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ConferenceTranslatorWeb.Telemetry,
      ConferenceTranslator.Repo,
      {DNSCluster, query: Application.get_env(:conference_translator, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ConferenceTranslator.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ConferenceTranslator.Finch},
      # Start a worker by calling: ConferenceTranslator.Worker.start_link(arg)
      # {ConferenceTranslator.Worker, arg},
      # Start to serve requests, typically the last entry
      ConferenceTranslatorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConferenceTranslator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ConferenceTranslatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
