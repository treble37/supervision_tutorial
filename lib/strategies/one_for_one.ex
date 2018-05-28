defmodule SupervisionTutorial.OneForOne do
  use Supervisor

  def start_link(_options) do
    Supervisor.start_link(__MODULE__, :one_f_one, name: __MODULE__)
  end

  def init(:one_f_one) do
    Supervisor.init([{FibWorker, name: :one_for_one_worker}], strategy: :one_for_one, max_restarts: 1)
  end

  def stop_workers do
    worker_pids()
    |> Enum.each(fn(pid) -> Supervisor.terminate_child(__MODULE__, pid) end)
  end

  def worker_pids do
    Supervisor.which_children(__MODULE__)
    |> Enum.reduce([], fn({_worker, pid, _type, _args}, acc) -> acc ++ [pid] end)
  end

  def worker_compute(n) do
    worker_compute(worker_pids(), n)
  end

  defp worker_compute([head | _tail], n) do
    GenServer.call(head, {:compute, n})
  end

  defp worker_compute([], _n) do
    {:ok, "no fibonacci workers exist"}
  end
end
