defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "Part 1 calc_fuel_required1" do
    assert Day1.calc_fuel_required1("12") == 2
    assert Day1.calc_fuel_required1("14") == 2
    assert Day1.calc_fuel_required1("1969") == 654
    assert Day1.calc_fuel_required1("100756") == 33583
  end

  test "Part 2 complete fuel requirements (good) fuel" do
    assert Day1.calc_fuel_required2("14") == 2
    assert Day1.calc_fuel_required2("1969") == 966
    assert Day1.calc_fuel_required2("100756") == 50346
  end
end
