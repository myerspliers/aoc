defmodule Aoc2019Test do
  use ExUnit.Case
  doctest Aoc2019

  test "calc_fuel_required part 1" do
    assert Day1.calc_fuel_required1("12") == 2
    assert Day1.calc_fuel_required1("14") == 2
    assert Day1.calc_fuel_required1("1969") == 654
    assert Day1.calc_fuel_required1("100756") == 33583
  end

  test "part 2 - recursive fuel requirements" do
    assert Day1.calc_fuel_required2("14") == 2
    assert Day1.calc_fuel_required2("1969") == 966
    assert Day1.calc_fuel_required2("100756") == 50346
  end
end
