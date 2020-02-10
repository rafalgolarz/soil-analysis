defmodule SoilAnalysis.LocationTest do
  use ExUnit.Case, async: true
  alias SoilAnalysis.Location
  doctest SoilAnalysis

  test "Creates new locations succesfully" do
    size = 2
    {:ok, _} = Location.new(%{{0, 0} => 1, {0, 1} => 2, {1, 0} => 3, {1, 1} => 4}, size)
  end

  test "Scores locations succesfully" do
    size = 2
    concentration = [1, 2, 3, 4]
    # in case of 2x2 grids, each location is scored the same value
    expected_score = Enum.sum(concentration)

    {:ok, _} = Location.new(%{{0, 0} => 1, {0, 1} => 2, {1, 0} => 3, {1, 1} => 4}, size)
    scores = Location.score()
    assert scores[{0, 0}] == expected_score
    assert scores[{0, 1}] == expected_score
    assert scores[{1, 0}] == expected_score
    assert scores[{1, 1}] == expected_score
  end

  test "Test single score succesfully" do
    size = 3

    {:ok, _} =
      Location.new(
        %{
          {0, 0} => 5,
          {0, 1} => 2,
          {0, 2} => 6,
          {1, 0} => 1,
          {1, 1} => 7,
          {1, 2} => 9,
          {2, 0} => 0,
          {2, 1} => 1,
          {2, 2} => 4
        },
        size
      )

    # calculate all scores
    scores = Location.score()
    # calculate single score for location (2,0) and its concentration 0
    {{_, _}, expected_score} = Location.single_score(2, 0, 0)
    # compare score from the list of scores to the single score
    assert scores[{2, 0}] == expected_score
  end
end
