defmodule GoogleSpanner.Session do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init([project: project, instance: instance, database: database]) do
    client = GoogleSpanner.RestApi.token() |> GoogleSpanner.RestApi.create_client
    session = GoogleSpanner.RestApi.create_session(client, project, instance, database)

    {:ok, [client: client, session: session]}
  end

  def handle_call({:query, query}, _from, state) do
    [client: client, session: session] = state
    result = GoogleSpanner.RestApi.query(client, session, query)
    {:reply, result, state}
  end

  def handle_call({:upsert, table, columns, rows}, _from, state) do
    [client: client, session: session] = state
    result = GoogleSpanner.RestApi.upsert(client, session, table, columns, rows)
    {:reply, result, state}
  end

  def query(pid, query) do
    GenServer.call(pid, {:query, query})
  end

  def upsert(pid, table, columns, rows) do
    GenServer.call(pid, {:upsert, table, columns, rows})
  end
end
