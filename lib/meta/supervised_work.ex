defmodule SupervisionTutorial.SupervisedWork do
  @moduledoc """
  Helper functions for starting, stopping, and having workers process data
  """
  defmacro __using__(options) do
    quote do
      import unquote(__MODULE__)
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
  end
end
