defmodule GoogleSpanner.RestApi do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://localhost:3011/"
  # plug Tesla.Middleware.BaseUrl, "https://spanner.googleapis.com/v1/"
  plug Tesla.Middleware.JSON

  @scopes [
    "https://www.googleapis.com/auth/spanner.data"
  ]

  def token() do
    {:ok, token} = Goth.Token.for_scope(Enum.join(@scopes, " "))
    token
  end

  def create_client(%Goth.Token{} = token) do
    Tesla.build_client([
      { Tesla.Middleware.Headers, %{"Authorization" => "#{token.type} #{token.token}"} },
    ])
  end

  def create_session(client, project, instance, database) do
    case post(client, "projects/#{project}/instances/#{instance}/databases/#{database}/sessions", %{}) do
      %Tesla.Env{body: %{"name" => session}} -> session
    end
  end

  def delete_session(client, session) do
      delete(client, session)
  end

  def query(client, session, query) do
    case post(client, session <> ":executeSql", %{"sql" => query}) do
      %Tesla.Env{status: 200, body: %{"metadata" => %{"rowType" => %{"fields" => fields}}, "rows" => rows}} ->
        headers = fields |> Enum.map(fn(%{"name" => name}) -> name end)
        rows |> Enum.map(&with_headers(&1, headers))
      %Tesla.Env{status: 200, body: %{"metadata" => %{"rowType" => %{"fields" => _}}}} -> []
    end
  end

  def upsert(client, session, table, columns, rows) do
    request_body = %{"singleUseTransaction" => %{"readWrite" => %{}}, "mutations" => [%{"insertOrUpdate" => %{"table" => table, "columns" => columns, "values" => rows}}]}
    case post(client, session <> ":commit", request_body) do
      %Tesla.Env{body: body} -> body
    end
  end

  defp with_headers(row, headers) do
      headers
      |> Enum.zip(row)
      |> Enum.into(%{})
  end
end
