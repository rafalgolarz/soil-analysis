defmodule SoilAnalysisTest do
  use ExUnit.Case, async: true
  doctest SoilAnalysis

  test "Sample Test 1" do
    scores = SoilAnalysis.process("1 5 5 3 1 2 0 4 1 1 3 2 2 3 2 4 3 0 2 3 3 2 1 0 2 4 3")
    # 5 + 3 + 1 + 4 + 1 + 1 + 2 + 3 + 2 = 22
    assert scores[{1, 1}] == 22
    # 5 + 3 + 4 + 1 = 13
    assert scores[{0, 0}] == 13
  end

  test "Sample Test 2" do
    scores = SoilAnalysis.process("1 3 4 2 3 2 2 1 3 2 1")
    # 4 + 2 + 3 + 2 + 2 + 1 + 3 + 2 + 1 = 20
    assert scores[{1, 1}] == 20
  end

  test "Sample Test 3" do
    scores = SoilAnalysis.process("1 5 5 3 1 2 0 4 1 1 3 2 2 3 2 4 3 0 2 3 3 2 1 0 2 4 3")
    # 2 + 4 + 3 + 3 + 3 + 2 + 2 + 4 + 3 = 26
    assert scores[{3, 3}] == 26
  end

  test "Sample Test 4" do
    scores = SoilAnalysis.process("3 4 2 3 2 1 4 4 2 0 3 4 1 1 2 3 4 4")

    assert scores[{1, 2}] !== 27
    assert scores[{1, 1}] == 25
    assert scores[{2, 2}] == 23

    assert scores[{2, 1}] == 27
  end

  test "Testing long lists (10x10)" do
    scores = SoilAnalysis.process("3 10
    2 6 6 6 2 4 5 3 0 5
    0 8 6 0 1 5 3 0 6 9
    3 1 1 9 2 3 6 5 3 6
    6 7 9 1 1 6 2 9 2 9
    0 5 5 4 2 9 8 1 9 1
    0 2 1 3 5 9 3 3 9 8
    4 9 7 4 2 1 5 3 1 1
    8 7 4 4 7 4 2 1 6 5
    9 5 8 0 8 0 5 7 9 7
    8 7 7 8 8 4 5 8 4 4")

    assert scores[{1, 2}] == 43
    assert scores[{9, 9}] == 24
  end
end
