defmodule SupervisionTutorial.Dynamic do
  use DynamicSupervisor

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
    #registered_name = Process.info(head) |> Keyword.fetch!(:registered_name)
    GenServer.call(head, {:compute, n})
  end

  defp worker_compute([], _n) do
    {:ok, "no fibonacci workers exist"}
  end
end
