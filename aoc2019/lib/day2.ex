defmodule Day2 do
  @moduledoc """
  Solutions for day 2
  """

  @min_search 1
  @max_search 99

  def gravity_assist(path) do
    process_input_file(path)
    |> run_program
  end

  @doc """
  Process an intcode program file, and return a map with indexed intcode instructions
  """
  @spec process_input_file(fname :: String.t()) :: List.t()
  def process_input_file(fname) when is_binary(fname) do
    File.read!(fname)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Run an intcode program, codes is a list of tuples {int-code, index}
  """
  def run_program(codes) when is_list(codes) do
    #TODO: Move this map creation in to process_input_file for more streaming, but have to change tests.
    codes_map =
      Stream.with_index(codes)
      |> Enum.into(%{}, fn ({v,k}) -> {k, v}  end)

    next_instruction(codes_map, 0, map_size(codes_map))
  end


  def next_instruction(codes, pos, end_pos) when pos >= end_pos, do: codes

  def next_instruction(codes, pos, end_pos) do
    {next_pos, codes} = run_instruction(Map.get(codes, pos), codes, pos)

    case next_pos do
      -1 ->
        IO.puts("# Done return the final result (just a list of the codes)")
        Map.values(codes)

      _valid_pos ->
        next_instruction(codes, next_pos, end_pos)
    end
  end

  # Used for instructions like add, mult to get the values
  # in the next 2 positions after the instruction code.
    def call_next_2(codes, pos, fun) do
    keys = [i1, i2, dest] = [pos + 1, pos + 2, pos + 3]
    IO.inspect(dest, label: "--dest")
    %{^i1 => a1, ^i2 => a2} = Map.take(codes, keys)
    {Map.get(codes, dest), fun.(Map.get(codes, a1), Map.get(codes, a2))}
  end

  # End program
  defp run_instruction(99, codes, _pos) do
    {-1, codes}
  end

  # add
  defp run_instruction(1, codes, pos) do
    {dest, val} = call_next_2(codes, pos, &Kernel.+/2)
    {pos + 4, Map.put(codes, dest, val)}
  end

  # multiply
  defp run_instruction(2, codes, pos) do
    {dest, val} = call_next_2(codes, pos, &Kernel.*/2)
    {pos + 4, Map.put(codes, dest, val)}
  end


end
