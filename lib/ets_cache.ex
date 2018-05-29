defmodule EtsCache do
  def write(table_name, key, value) do
    find_or_create_table(no_table?(table_name), table_name)
    :ets.insert(table_name, {key, value})
    read(table_name, key)
  end

  def upsert(table_name, key, value) do
    case read(table_name, key) do
      nil ->
        write(table_name, key, value)
      value ->
        value
    end
  end

  def read(table_name, key) do
    find_or_create_table(no_table?(table_name), table_name)
    case :ets.lookup(table_name, key) do
      [{_, value}] ->
        value
      _ ->
        nil
    end
  end

  defp find_or_create_table(true, table_name) do
    :ets.new(table_name, [:named_table])
  end

  defp find_or_create_table(false, table_name) do
    :ets.info(table_name)[:name]
  end

  defp no_table?(table_name) do
    :ets.info(table_name) == :undefined
  end
end
