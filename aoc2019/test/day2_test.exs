defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  @test_0 %{in: [1,9,10,3,2,3,11,0,99,30,40,50], out: [3500,9,10,70,  2,3,11,0,  99,  30,40,50]}
  @test_1 %{in: [1,0,0,0,99], out: [2,0,0,0,99]}
  @test_2 %{in: [1,1,1,4,99,5,6,0,99], out: [30,1,1,4,2,5,6,0,99]}

  @tag day: 2
  test "Part 1 Intcode" do
    assert Day2.run_program(@test_0.in) == @test_0.out
    assert Day2.run_program(@test_1.in) == @test_1.out
    assert Day2.run_program(@test_2.in) == @test_2.out
  end

  @tag day: 2
  test "Part 2" do
    assert Day2.find_solution("input/day2.test", 3500) == {9, 10} || {10, 9} || {69, 1}
  end
end

# Day2.find_solution("input/day2.input", 19690720)
