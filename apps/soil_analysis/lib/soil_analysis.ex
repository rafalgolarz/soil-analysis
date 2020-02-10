defmodule SoilAnalysis do
  alias SoilAnalysis.Grid
  alias SoilAnalysis.Location

  @moduledoc """
  Module provides an interface to process and display results of analysed data.
  """

  @doc """
  Process the given input and return scores for each location
  This function is responsible only for processing results, not formatting.
  """
  def process(input) do
    listed =
      input
      |> input_to_list()

    # we don't need number of requested results at this point
    [_ | [size_of_the_grid | concentration_values]] = listed

    with {:ok, _} <- Grid.new(size_of_the_grid, concentration_values),
         {:ok, _} <- Location.new(Grid.locations(), size_of_the_grid) do
      scores = Location.score()

      # release resources
      Location.clean()
      Grid.clean()
      scores
    end
  end

  @doc """
  Display results in (x, y, score: score) format
  """
  def top_scores(input) do
    # extract first param (number of requested results)
    listed =
      input
      |> input_to_list

    # extract first param (number of requested results)
    [number_of_results | _] = listed

    # if we pass incorrect number of expected results to Enum.take
    # it will display all results
    top =
      process(input)
      |> Enum.sort(&(elem(&1, 1) > elem(&2, 1)))
      |> Enum.take(number_of_results)

    for {{x, y}, score} <- top, do: IO.puts("(#{x}, #{y}, score: #{score})")
  end

  @doc """
  A helper for transorming a string of values to a string of values
  """
  def input_to_list(input) do
    input
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
