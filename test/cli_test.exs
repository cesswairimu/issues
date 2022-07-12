defmodule CliTest do
  use ExUnit.Case
  doctest JulyIssues

  import JulyIssues.CLI, only: [ parse_args: 1 ]

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
end
