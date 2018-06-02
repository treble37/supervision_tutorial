defmodule SupervisionTutorial.OneForAll do
  use Supervisor
  use SupervisionTutorial.SupervisedWork

  def start_link(_options) do
    Supervisor.start_link(__MODULE__, :one_f_all, name: __MODULE__)
  end

  def init(:one_f_all) do
    children = [{FibWorker, name: :one_for_all_worker, state: 0}]
    Supervisor.init(children, strategy: :one_for_all, max_restarts: 1)
  end
end
