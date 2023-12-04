defmodule Aoc.Day2 do

  @path_day2 "./resources/adventofcode.com_2023_day_2_input.txt"
  def day2() do
    file_stream = File.stream!(@path_day2, [], :line)
    solution_2(file_stream, %{"red" => 12, "green" => 13, "blue" => 14})
  end

  @path_day2 "./resources/adventofcode.com_2023_day_2_input.txt"
  def day2_part2() do
    file_stream = File.stream!(@path_day2, [], :line)
    solution_2_part2(file_stream)
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

  def solution_2_part2(data) do
    data
    |> Enum.map(fn line -> String.split(line, ":", trim: true) end)
    |> Enum.map(fn [game_id, game] ->
      [game_id, game |> String.trim("\n") |> String.split(";", trim: true)]
    end)
    |> Enum.reduce(%{}, fn [id, games], acc ->
      Map.put(acc, game_id_from_string(id), game_kv(games))
    end)
    |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k, game_merge_max(v)) end)
    |> Enum.map(fn {_k, v} -> Map.values(v) end)
    |> Enum.map(fn powers -> Enum.reduce(powers, 1, fn p, acc -> p * acc end) end)
    |> Enum.sum()
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
