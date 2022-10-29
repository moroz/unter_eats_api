defmodule UnterEats.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @migrator if Mix.env() == :prod, do: [UnterEats.Migrator], else: []

  @impl true
  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        UnterEats.Repo,
        # Start the Telemetry supervisor
        UnterEatsWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: UnterEats.PubSub},
        # Start the Endpoint (http/https)
        UnterEatsWeb.Endpoint
        # Start a worker by calling: UnterEats.Worker.start_link(arg)
        # {UnterEats.Worker, arg}
      ] ++ @migrator

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UnterEats.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UnterEatsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
