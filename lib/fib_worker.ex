defmodule FibWorker do
  require EtsCache
  use GenServer

  # children_list = Supervisor.which_children(SupervisionTutorial.OneForOne)
  # pid = Process.whereis(:FibWorker) #=> nil or #PID<0.120.0>
  # GenServer.call(pid, {:compute, 13}) #=> 233
  def start_link(args) do
    GenServer.start_link(__MODULE__, args[:state], [name: args[:name]])
  end

  def init(args) do
    {:ok, args}
  end

  def compute(n, worker_name) do
    #GenServer.call(__MODULE__, {:compute, n}, 200000)
    GenServer.call(worker_name, {:compute, n}, 200000)
  end

  def handle_call({:compute, n}, _from, state) do
    fib_val = Fibonacci.fib(n)
    EtsCache.upsert(:fibonacci, n, fib_val)
    {:reply, fib_val, state}
  end
end
