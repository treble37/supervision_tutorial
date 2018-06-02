defmodule SupervisionTutorial.RestForOne do
  use Supervisor
  use SupervisionTutorial.SupervisedWork

  def start_link(_options) do
    Supervisor.start_link(__MODULE__, :rest_f_one, name: __MODULE__)
  end

  def init(:rest_f_one) do
    children = [{FibWorker, name: :rest_for_one_worker, state: 0}]
    Supervisor.init(children, strategy: :rest_for_one, max_restarts: 1)
  end
end
