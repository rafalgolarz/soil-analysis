defmodule SoilAnalysis.GridTest do
  use ExUnit.Case, async: true
  alias SoilAnalysis.Grid
  doctest SoilAnalysis

  test "Fail creating a grid due to incorrect size" do
    size = 1
    concentration = [1, 2, 3, 10]
    refute match?({:ok, _}, Grid.new(size, concentration))
  end

  test "Fail creating a grid due to values outside the acceptable range" do
    size = 2
    concentration = [1, 2, 3, 10]
    refute match?({:ok, _}, Grid.new(size, concentration))
  end

  test "Fail creating a grid due to non integer values" do
    size = 2
    concentration = [1, 2, 3, "a"]
    refute match?({:ok, _}, Grid.new(size, concentration))
  end

  test "Fail creating a grid due not passing concentration as a list" do
    size = 2
    concentration = "not a list"
    refute match?({:ok, _}, Grid.new(size, concentration))
  end

  test "Fail creating a grid as there's less locations than the size requires" do
    size = 3
    concentration = [1, 2, 3, 9]
    refute match?({:ok, _}, Grid.new(size, concentration))
  end

  test "Fail creating a grid as there's more locations than the size requires" do
    size = 2
    concentration = [1, 2, 3, 9, 5]
    refute match?({:ok, _}, Grid.new(size, concentration))
  end
end
