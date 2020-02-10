defmodule SoilAnalysis.Location do
  alias SoilAnalysis.Location

  @moduledoc """
  This module has the key logic for calculations of scores.
  """

  defstruct locations: %{}, scores: %{}, size: 2
  @pid_name __MODULE__

  def new(grid2D, size) do
    Agent.start_link(fn -> %Location{locations: grid2D, size: size} end, name: @pid_name)
  end

  def clean do
    Agent.stop(@pid_name)
  end

  @doc """
  getter for locations
  """
  def locations do
    Agent.get(@pid_name, fn state -> state.locations end)
  end

  @doc """
  getter for size
  """
  def size do
    Agent.get(@pid_name, fn state -> state.size end)
  end

  @doc """
  getter for scores
  """
  def scores do
    Agent.get(@pid_name, fn state -> state.scores end)
  end

  @doc """
  applying score to each location
  """
  def score do
    scores =
      for {loc, val} <- locations(),
          {x, y} = loc,
          into: %{},
          do: single_score(x, y, val)

    Agent.update(@pid_name, fn state -> Map.put(state, :scores, scores) end)
    scores
  end

  def single_score(x, y, val) do
    loc = locations()

    # instead of checking if a location is on the edge
    # I simply assign 0 to non-existing neighbours
    n1 = loc[{x + 1, y}] || 0
    n2 = loc[{x - 1, y}] || 0
    n3 = loc[{x, y - 1}] || 0
    n4 = loc[{x, y + 1}] || 0
    n5 = loc[{x + 1, y + 1}] || 0
    n6 = loc[{x - 1, y + 1}] || 0
    n7 = loc[{x - 1, y - 1}] || 0
    n8 = loc[{x + 1, y - 1}] || 0

    score = val + n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8

    {{x, y}, score}
  end
end
