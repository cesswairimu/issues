defmodule JulyIssues.CLI do

  import JulyIssues.TableFormatter, only: [ print_table_for_columns: 2]

  @default_count 4

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [ help: :boolean ],
                             aliases:  [ h:    :help ] )
      |> elem(1)
      |> args_to_internal_representation()
  end


  def args_to_internal_representation([ user, project, count ]) do
    { user, project, String.to_integer(count) }
  end

  def args_to_internal_representation([ user, project ]) do
    { user, project, @default_count }
  end

  def args_to_internal_representation(_) do
    :help
  end

  # process :help or name, project, count when given
  def process(:help) do
    IO.puts """
    usage:  issues <user> <project> [ count | 4 ]
    """
    System.halt(0)
  end

  def process({ user, project, count }) do
    JulyIssues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_in_desc_order()
    |> last(count)
    |> print_table_for_columns(["number", "created_at", "title", "state", "comments_url", "node_id", "labels[:description]"])
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts "##ERROR fetching from Github ### ==== #{error["message"]}"
    System.halt(2)
  end

  def sort_in_desc_order(list) do
    list
    |> Enum.sort( fn arg1, arg2 ->
       arg1["created_at"] >= arg2["created_at"] 
      end)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse
  end

 
end
