defmodule Day1 do
  @moduledoc """
  Day 1 puzzels for Advent of Code 2019
  """

  #////////////////////////////////////////////////////////////////////////////////
  #Puzzle 2
  def fuel_sum2(input) do
    File.stream!(input)
    |> Enum.reduce(0, fn x, total ->
      calc_fuel_required2(x) + total
    end)
  end

  def calc_fuel_required2(weight) when is_binary(weight) do
    case Integer.parse(weight) do
      {num, _rest} -> calc_total_fuel(num, 0)
      _ -> 0
    end
  end

  @doc """
  Recursively calculate the fuel required for a module's mass + fuel for the mass of the fuel.
  """
  def calc_total_fuel(mass, total) when is_integer(mass) and mass < 9 do
    total
  end

  def calc_total_fuel(mass, total) when is_integer(mass) do
    fmass = div(mass, 3) - 2
    calc_total_fuel(fmass, total + fmass)
  end

  #////////////////////////////////////////////////////////////////////////////////
  # Puzzle 1
  def fuel_sum(input) do
    File.stream!(input)
    |> Enum.reduce(0, fn x, total ->
      calc_fuel_required1(x) + total
    end)
  end

  def calc_fuel_required1(weight) when is_binary(weight) do
    case Integer.parse(weight) do
      {num, _rest} -> div(num, 3) - 2
      _ -> 0
    end
  end
end
