defmodule Fibonacci do
  @table_name :fibonacci
  require EtsCache
  # this module will represent "computation work" to be done in a process
  # Get the next number in the fibonacci sequence

  def fib(0), do: 0
  def fib(1), do: 1
  def fib(term) do
    get_fib_term(term-1) + get_fib_term(term-2)
  end

  def get_fib_term(term) do
    case fib_cached?(term) do
      false ->
        EtsCache.write(@table_name, term, fib(term))
      true ->
        EtsCache.read(@table_name, term)
    end
  end

  def fib_cached?(term) do
    EtsCache.read(@table_name, term) != nil
  end
end
