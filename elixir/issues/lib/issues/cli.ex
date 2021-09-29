defmodule Issues.CLI do
  @default_count 4

  def run(argv) do
    argv
    |> parse_args
    |> process
  end
  def parse_args(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal_representiation()
  end

  def args_to_internal_representiation([user, project, count]),
    do: {user, project, String.to_integer(count)}

  def args_to_internal_representiation([user, project]), do: {user, project, @default_count}

  def args_to_internal_representiation(_), do: :help

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
  end
end
