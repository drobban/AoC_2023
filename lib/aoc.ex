defmodule Aoc do
  @moduledoc """
  Documentation for `Aoc`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc.hello()
      :world

  """
  def hello do
    :world
  end

  @path_day1 "./resources/adventofcode.com_2023_day_1_input.txt"
  def day1() do
    file_stream = File.stream!(@path_day1, [], :line)
    solution_1(file_stream)
  end

  def day1_part2() do
    file_stream = File.stream!(@path_day1, [], :line)
    file_stream
    |> Aoc.part_2_process()
    |> solution_1()
  end

  def solution_1(data) do
    data
    |> Enum.reduce([], fn line, acc ->
      [String.replace(line, ~r/[^\d]/, "") |> String.split("", trim: true) | acc]
    end)
    |> Enum.map(fn line -> [Enum.at(line, 0), Enum.at(line, -1)] end)
    |> Enum.map(fn [h, l] -> String.to_integer("#{h}#{l}") end)
    |> Enum.sum()
  end

  def part_2_process(data) do
    nums = %{
      "one" => "one1one",
      "two" => "two2two",
      "three" => "three3three",
      "four" => "four4four",
      "five" => "five5five",
      "six" => "six6six",
      "seven" => "seven7seven",
      "eight" => "eight8eight",
      "nine" => "nine9nine"
    }

    data
    |> Enum.map(fn line -> process_number(line, nums) end)
  end

  def process_number(line, translation) do
    translation
    |> Enum.reduce(line, fn {k, v}, acc -> String.replace(acc, k, v)  end)
  end

  @path_day2 "./resources/adventofcode.com_2023_day_2_input.txt"
  def day2() do
    file_stream = File.stream!(@path_day2, [], :line)
    solution_2(file_stream, %{"red" => 12, "green" => 13, "blue" => 14})
  end

  def solution_2(data, criteria) do
    max_possible =
      data
      # |> Enum.map(fn line -> String.trim("\n") end)
      |> Enum.map(fn line -> String.split(line, ":", trim: true) end)
      |> Enum.map(fn [game_id, game] ->
        [game_id, game |> String.trim("\n") |> String.split(";", trim: true)]
      end)
      |> Enum.reduce(%{}, fn [id, games], acc ->
        Map.put(acc, game_id_from_string(id), game_kv(games))
      end)
      |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k, game_merge_max(v)) end)

    max_possible
    |> Enum.map(fn {id, game} ->
      {id, Map.filter(game, fn {k, v} -> v <= Map.get(criteria, k) end)}
    end)
    |> Enum.filter(fn {_id, game} -> Enum.count(game) == 3 end)
    |> Enum.reduce(0, fn {id, _game}, acc -> acc + id end)
  end

  def game_id_from_string(game_id) do
    game_id
    |> String.split(" ", trim: true)
    |> Enum.at(-1)
    |> String.to_integer()
  end

  def game_kv(games) do
    games
    |> Enum.map(fn game -> String.split(game, ",", trim: true) end)
    |> Enum.map(fn sets ->
      Enum.map(sets, fn set -> String.split(set, " ", trim: true) end)
      |> Enum.reduce(%{}, fn [v, k], acc -> Map.put(acc, k, String.to_integer(v)) end)
    end)
  end

  def game_merge_max(games) do
    games
    |> Enum.reduce(%{}, fn game, acc -> Map.merge(acc, game, fn _k, v1, v2 -> max(v1, v2) end) end)
  end
end
