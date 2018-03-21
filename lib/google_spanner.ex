defmodule GoogleSpanner do

  def start(project, instance, database) do
    config = [
      {:name, {:local, :connection_pool}},
      {:worker_module, GoogleSpanner.Session},
      {:size, 2},
      {:max_overflow, 1}
    ]

    children = [
      :poolboy.child_spec(:connection_pool, config, [project: project, instance: instance, database: database])
    ]

    options = [
      strategy: :one_for_one,
      name: GoogleSpanner.Session
    ]

    case Supervisor.start_link(children, options) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
    end
  end

  def query(query) do
    :poolboy.transaction(:connection_pool, &(GoogleSpanner.Session.query(&1, query)))
  end

  def upsert(table, columns, rows) do
    :poolboy.transaction(:connection_pool, &(GoogleSpanner.Session.upsert(&1, table, columns, rows)))
  end
end
