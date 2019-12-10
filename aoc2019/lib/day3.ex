defmodule Day3 do
  @doc """
  Part 1: Process a wire paths file, each line is a wire and gives the path it takes.
  """
  @spec process_input_file(fname :: String.t()) :: List.t()
  def process_input_file(fname) when is_binary(fname) do

    #TODO: Try Stream not Enum where possible.
    File.stream!(fname)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line ->
      String.split(line, ",")
      |> Enum.map(&String.trim/1)
    end)
  end

#    |> String.split("\n", trim: true)

  def find_closest_intersection(path) when is_binary(path) do
    process_input_file(path)
    |> find_closest_intersection
  end

  def find_closest_intersection(wire_paths_list) when is_list(wire_paths_list) do
    wire_paths_list
    |> get_wire_maps
    |> get_intersections
    |> get_shortest_intersection
  end

# recieve a list of wire paths (direction and distance), e.g., ["U2","L3","D1"]
# return a list of MapSets containing the points of the wires.
def get_wire_maps(paths_list) do
  Enum.map(paths_list, &get_wire_points/1)
end

# Turn a wire path list into a MapSet of points that the wire covers.
def get_wire_points(wire_path) when is_list(wire_path) do
  do_get_wire_points(wire_path, 0, 0, [])
  |> MapSet.new
end


def do_get_wire_points([], _x, _y, wire_points) do
  wire_points
end

def do_get_wire_points([head | rest], start_x, start_y, wire_points) do
  {next_x, next_y, point_list} = path_to_points(head, start_x, start_y)

  wire_points = point_list ++ wire_points

  do_get_wire_points(rest, next_x, next_y, wire_points)
end

# Find an interseection of all MapSets in a list
@spec get_shortest_intersection(MapSet.t(any)) :: MapSet.t(any)
def get_shortest_intersection(intersection_map) do
  MapSet.to_list(intersection_map)
  |> Enum.reduce(999999999, fn p, min_dist ->
      min(min_dist, get_distance(p))
    end)
end

# The distance of a point from the 0,0 origin.
defp get_distance({x, y}), do: abs(x) + abs(y)

@doc """
Get the intersection of all the maps in a list.
"""
#@spec get_intersections()
def get_intersections([first_map | other_maps]) do
  Enum.reduce(other_maps, first_map, fn(x, acc) -> MapSet.intersection(acc, x) end)
end

@doc """
Convert a wire path element like "U3" to list of tuples containing the points
covered by following the given direction and distance when starting at the given
x, y start points.
Returns a tuple with the last point's x and y with a list of all the x/y point tuples.

#Examples
iex> Day3.path_to_points("U3", 4, -1)
{4, -1, [{4, -1}, {4, 0}, {4, 1}, {4, 2}]}
"""
def path_to_points(<<direction, dist::binary>>, x_start, y_start) do#Match "R\d*"
  dist = String.to_integer(dist)
  case direction do
    # Add or subtract 1 from the start to skip the starting point.
    ?L -> make_points( {x_start - 1, x_start - dist}, y_start )
    ?R -> make_points( {x_start + 1, x_start + dist}, y_start )  #right, y stays the same x increases for every step
    ?U -> make_points( x_start, {y_start + 1, y_start + dist} )
    ?D -> make_points( x_start, {y_start - 1, y_start - dist} )
  end
end

# for Y changing direction up or down (U or D)
def make_points(x, {y1, y2}) when is_integer(x) do
  {x, y2, Enum.map(y1..y2, &({x, &1}))}
end

# for X changing direction right or left (L or R)
def make_points({x1, x2}, y) when is_integer(y) do
  {x2, y, Enum.map(x1..x2, &({&1, y}))}
end

end
