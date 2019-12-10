defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  @test_wires [["U2","L3","D1"], ["L2", "U7", "R4"]] # Intersection at {-2, 2} = Manhattan distance of 4

  @tag day: 3
  test "path_to_points" do
    assert Day3.path_to_points("D2", 3, 44) == {3, 42, [{3, 43}, {3, 42}]}
    assert Day3.path_to_points("U3", 5, -2) == {5, 1, [{5, -1}, {5, 0}, {5, 1}]}
    assert Day3.path_to_points("L4", 55, 8) == {51, 8, [{54, 8}, {53, 8}, {52, 8}, {51, 8}]}
    assert Day3.path_to_points("R5", -77, 10) == {-72, 10, [{-76, 10}, {-75, 10}, {-74, 10}, {-73, 10}, {-72, 10}]}
  end

  @tag day: 3
  test "get intersection" do
    inter_map =
      Day3.get_wire_maps(@test_wires)
      |> Day3.get_intersections
    assert inter_map == MapSet.new([{-2, 2}])
  end

  @tag day: 3
  test "manhattan distance lists" do
    assert Day3.find_closest_intersection(@test_wires) == 4
    assert Day3.find_closest_intersection([["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
    ["U62","R66","U55","R34","D71","R55","D58","R83"]]) == 159
  end

end
