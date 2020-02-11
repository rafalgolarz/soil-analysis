defmodule SoilAnalysis.Grid do
  alias SoilAnalysis.Grid

  @moduledoc """
  A module that transforms a list of concentration values to a 2D grid with x,y locations.

  A grid represents the concentration of sought resource in a soil sample.
  A resource could be water or really anything else presented on a map.
  (I'm avoiding tiding up code just to water, trying to make the code more generic)
  """

  # minimum size of the grid (2x2)
  # NOTE: top left cell has x,y coordinations 0,0
  @min_size 2
  # minimal value of concentration
  @minc 0
  # maximum value of concentration
  @maxc 9

  @doc """
  A struct representing a grid of analysed area.

  ## Parameters
    - size: the size of the grid
    - concentration: a list of numbers that form the grid
      (will always range from 0 (no resource detected) to 9 (lots of sought resources)
    - locations is a 2D grid with values assigned to (x,y) positions
  """
  defstruct size: @min_size, concentration: [@minc, @minc, @minc, @minc], locations: %{}
  @pid_name __MODULE__

  @doc """
  creates a new grid of size "s" with elements stored in the "c" list
  """
  def new(s, c) do
    with {:ok, size} <- validate_size(s),
         {:ok, concentration} <- validate_concentration(c),
         {:ok, concentration} <- validate_size_against_number_of_elements(size, concentration) do
      # each grid will persist within its own process
      Agent.start_link(fn -> %Grid{size: size, concentration: concentration} end,
        name: @pid_name
      )
    else
      err -> err
    end
  end

  def clean do
    Agent.stop(@pid_name)
  end

  ### getter for size of the grid
  defp size do
    Agent.get(@pid_name, fn state -> state.size end)
  end

  ### getter for the list of concentration values
  defp concentration do
    Agent.get(@pid_name, fn state -> state.concentration end)
  end

  @doc """
  transform a list of locations to a 2D grid of locations
  """
  def locations do
    build2D()
    Agent.get(@pid_name, fn state -> state.locations end)
  end

  # at that stage we should have a validated list against size and values
  # let's turn a flat list to 2D grid with (x, y) coordinates
  # [1, 2, 3, 4] turns into %{{0, 0} => 1, {0, 1} => 2, {1, 0} => 3, {1, 1} => 4}
  defp build2D do
    edge = size() - 1

    locations =
      for row <- 0..edge,
          col <- 0..edge,
          into: %{},
          do: {{row, col}, single_measurement(row, col)}

    Agent.update(@pid_name, fn state -> Map.put(state, :locations, locations) end)
  end

  # lookup for a value of concentration in the list
  # based on row and column in the grid
  # the value of each location (x,y) can be found using this pattern:
  # pos = row * grid_size + col
  defp single_measurement(row, col) do
    concentration_list = concentration()
    size = size()

    Enum.at(concentration_list, row * size + col)
  end

  ##################################################

  # validators of grid params
  defp validate_size(nil), do: {:error, "size is required"}
  defp validate_size(s) when not is_integer(s), do: {:error, "size must be integer"}

  defp validate_size(s) when s < @min_size,
    do: {:error, "size cannot be smaller than #{@min_size}"}

  defp validate_size(s), do: {:ok, s}

  defp validate_concentration(c) do
    if is_list(c) &&
         Enum.all?(c, &is_integer/1) &&
         Enum.all?(c, fn x -> x >= @minc && x <= @maxc end) do
      {:ok, c}
    else
      {:error, "concentration values must be a list of values in range of #{@minc}..#{@maxc}"}
    end
  end

  # As we're giving the size of a grid (instead of rows and columns),
  # the grid is always going to be a square.
  # That means that size * size should be equal the number of elements in the list.
  defp validate_size_against_number_of_elements(size, concentration) do
    if size * size == length(concentration) do
      {:ok, concentration}
    else
      {:error, "The size of the grid does not match the required number of concentration values"}
    end
  end
end
