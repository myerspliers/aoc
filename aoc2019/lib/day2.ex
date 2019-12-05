defmodule Day2 do
  @moduledoc """
  Solutions for day 2
  """

  @min_search 1
  @max_search 99

  # Get the next {noun, verb} to use in finding a solution for an
  # intcode program
  defp get_next_search({noun, verb}, search_start, search_end) when is_integer(noun) do
    n = noun + 1
    v = verb + 1

    cond do
      n > search_end && v > search_end ->
        # Reached the end of the search space, nothing else to try.
        {:end, search_end}

      n <= search_end ->
        {n, verb}

      n >= search_end ->
        {search_start, v}
    end
  end

  # Handle any non-integer nouns
  defp get_next_search(_noun_verb, _search_start, search_end) do
    {:end, search_end}
  end

  @doc """
  Run an intcode program substituting `{n, v}` for the noun and verb in
  the 1st and 2nd offsets of the program.
  """
  @spec run_permutation(memory :: List.t(), noun_verb :: tuple) :: List.t() | nil
  def run_permutation(_memory, {:end, _}), do: nil # no solution.

  def run_permutation(memory, {n, v}) do
    List.replace_at(memory, 1, n) # replace the noun (index 1)
    |> List.replace_at(2, v)      # replace the verb (index 2)
    |> run_program
  end

  # Stop the search for a solution when run_permutation returns nil
  defp check_result(nil, _solution) do
    {:halt, "no solution"}
  end

  # Check if the `result` from running an intcode program is the `solution` we're looking for.
  # Success is when the first item in `result` equals `solution`.
  defp check_result(result, solution) when is_list(result) do
    case List.first(result) do
      ^solution -> {:ok, solution}
      _ -> {:error, solution}
    end
  end


  # Recursively search for a solution by running the program, getting
  # `noun` and `verb` permutations from `get_next_search`
  defp do_find_solution({n_prev, v_prev}, memory, solution) do
    noun_verb = get_next_search({n_prev, v_prev}, @min_search, @max_search)
    result = run_permutation(memory, noun_verb)

    case check_result(result, solution) do
      {:halt, reason} -> {:error, reason}
      {:ok, _} -> noun_verb
      _ -> do_find_solution(noun_verb, memory, solution)
    end
  end

  def find_solution(path, solution) when is_binary(path) and is_integer(solution) do
    memory = process_input_file(path)
    do_find_solution({0, 1}, memory, solution)
  end

  def gravity_assist(path) do
    process_input_file(path)
    |> run_program
  end

  @doc """
  Process an intcode program file, and return a list with the intcode instructions
  """
  @spec process_input_file(fname :: String.t()) :: List.t()
  def process_input_file(fname) when is_binary(fname) do
    File.read!(fname)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def run_program(codes) when is_list(codes) do
    do_instruction(codes, 0, length(codes))
  end

  def do_instruction(codes, pos, end_pos) when pos >= end_pos, do: codes

  def do_instruction(codes, pos, end_pos) do
    offset = Enum.slice(codes, pos, 4)

    case offset do
      # add
      [1, a1, a2, dest | _rest] ->
        List.replace_at(codes, dest, Enum.at(codes, a1) + Enum.at(codes, a2))
        |> do_instruction(pos + 4, end_pos)

      # multiply
      [2, a1, a2, dest | _rest] ->
        List.replace_at(codes, dest, Enum.at(codes, a1) * Enum.at(codes, a2))
        |> do_instruction(pos + 4, end_pos)

      [99 | _rest] ->
        codes
    end
  end
end
