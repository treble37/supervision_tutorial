defmodule SupervisionTutorial.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: SupervisionTutorial.Worker.start_link(arg)
      # {SupervisionTutorial.Worker, arg},
      SupervisionTutorial.OneForOne,
      SupervisionTutorial.OneForAll,
      {DynamicSupervisor, strategy: :one_for_one, name: SupervisionTutorial.Dynamic}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    # As of Elixir 1.6.5, one_for_one is the only strategy you can use with a Dynamic Supervisor
    opts = [strategy: :one_for_one, restart: :transient, name: SupervisionTutorial.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
