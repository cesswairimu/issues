defmodule CliTest do
  use ExUnit.Case
  doctest JulyIssues

  import JulyIssues.CLI, only: [ parse_args: 1, sort_in_desc_order: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "3 values returned if 3 given" do
    assert parse_args(["cesswairimu", "shahada", "5"]) == { "cesswairimu", "shahada", 5 }
  end

  test "default count used if 2 args given" do
    assert parse_args(["user", "project_name"]) == { "user", "project_name", 4 }
  end

  test "sorts list returned in an desc order" do
    result = sort_in_desc_order(fake_list(["c", "b", "a"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{ c b a}
  end

  defp fake_list(values) do
    for value <- values,
    do: %{ "created_at" => value, "other_data" => "cccc" }
  end
end
