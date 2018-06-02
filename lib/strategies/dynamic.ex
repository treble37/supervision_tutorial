defmodule SupervisionTutorial.Dynamic do
  use DynamicSupervisor
  use SupervisionTutorial.SupervisedWork

  def start_link(_options) do
    Supervisor.start_link(__MODULE__, :dynamic_sup, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(max_children: 5000, strategy: :one_for_one)
  end

  # start_workers is for this dynamic supervisor
  def start_worker(name) do
    DynamicSupervisor.start_child(__MODULE__, {FibWorker, name: name, state: 0})
  end
end
