defmodule Issues.GithubIssues do
  @user_agent [{"user-agent", "Elixir dave@pragprog.com"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    [
      status_code |> checj_for_error(),
      body |> Poison.Parser.parse!()
    ]
  end

  defp checj_for_error(200), do: :ok
  defp checj_for_error(_), do: :error

end
