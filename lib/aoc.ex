defmodule Aoc do
  require Logger
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
    |> Enum.reduce(line, fn {k, v}, acc -> String.replace(acc, k, v) end)
  end

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

  @path_day3 "./resources/adventofcode.com_2023_day_3_input.txt"
  def day3() do
    file_stream = File.stream!(@path_day3, [], :line)
    solution_3(file_stream)
  end

  def solution_3(data) do
    # create window of two rows long. merge and compare.
    # n groups or group size indicates adjacent symbol
    # lines =

    hit_map =
      {
        data
        |> Enum.map(fn line -> String.replace(line, "\n", "") |> String.replace(" ", "") end)
        |> Enum.map(fn line -> String.split(line, "", trim: true) end)
        |> Enum.to_list()
        |> Aoc.construct_zipped()
        |> Enum.to_list()
        |> Aoc.build_hit_table()
        |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k - 1, v) end),
        data
        |> Enum.map(fn line -> String.replace(line, "\n", "") end)
        |> Enum.map(fn line -> String.split(line, "", trim: true) end)
        |> Enum.to_list()
        |> Aoc.construct_zipped_rev()
        |> Enum.to_list()
        |> Aoc.build_hit_table()
      }
      |> merge_entries()

    numbers =
      data
      |> Enum.map(fn line ->
        line
        |> String.split(~r/[^\d]/, trim: true)
        |> Enum.map(fn x ->
          String.to_integer(x)
        end)
      end)

    hit_map
    |> Enum.reduce([], fn {idx, c}, acc ->
      selected =
        for e_idx <- c do
          numbers
          |> Enum.at(idx)
          |> Enum.at(e_idx)
        end

      acc ++ selected
    end)
    |> Enum.sum()

    hit_map
    # |> Stream.map(fn line -> String.replace(line, "\n", "") end)
    # |> Stream.map(fn line -> String.split(line, "", trim: true) end)
    # |> Enum.to_list()
  end

  def merge_entries({kv1, kv2} = _hit_maps) do
    k1 = Map.keys(kv1) |> MapSet.new()
    k2 = Map.keys(kv2) |> MapSet.new()

    intersect = MapSet.intersection(k1, k2)

    intersect
    |> Enum.reduce(%{}, fn k, acc ->
      e1 = Map.get(kv1, k) |> Map.get(:entries)
      e2 = Map.get(kv2, k) |> Map.get(:entries)
      unique = MapSet.new(e1 ++ e2)
      Map.put(acc, k, unique)
    end)
  end

  def construct_zipped(data) do
    l_padded = data ++ [List.duplicate(".", data |> Enum.at(0) |> Enum.count())]
    r_padded = [List.duplicate(".", data |> Enum.at(0) |> Enum.count())] ++ data

    # Zip every row with prev.
    # to ease col check

    l_padded
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, idx}, acc -> acc ++ [Enum.zip(line, Enum.at(r_padded, idx))] end)
  end

  def construct_zipped_rev(data) do
    l_padded = data ++ [List.duplicate(".", data |> Enum.at(0) |> Enum.count())]
    r_padded = [List.duplicate(".", data |> Enum.at(0) |> Enum.count())] ++ data

    # Zip every row with prev.
    # to ease col check

    r_padded
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, idx}, acc -> acc ++ [Enum.zip(line, Enum.at(l_padded, idx))] end)
  end

  def build_hit_table(data) do
    data
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {lines, idx}, acc ->
      Logger.debug(idx)
      Map.put(acc, idx, find_entries(lines)) end)
  end

  def find_entries(cols) do
    cols
    |> Enum.with_index()
    |> Enum.reduce(%{num_state: 0, char_state: 0, v_idx: 0, entries: []}, fn {{p1, p2}, idx},
      acc ->
        find_cond(acc, p2, p1)
    end)
  end

  def find_cond(state, p2, p1) do
    bool_reset = ["."]
    value_chars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    inv_char_state = bool_reset ++ value_chars

    cond do
      # "@111"
      # "@..."
      Map.get(state, :char_state) == 1 and p2 in value_chars and p1 in inv_char_state ->
        # Logger.debug("2")
        Map.update(state, :entries, [], fn entries -> entries ++ [Map.get(state, :v_idx)] end)
        |> Map.put(:char_state, 0)
        |> Map.put(:num_state, 1)


      # "111."
      # "...@"
      # Add entry and increase, reset num_state
      Map.get(state, :num_state) == 1 and p2 in bool_reset and p1 not in inv_char_state ->
        # Logger.debug("1")
        Map.update(state, :entries, [], fn entries -> entries ++ [Map.get(state, :v_idx)] end)
        |> Map.put(:char_state, 1)
        |> Map.put(:num_state, 0)
        |> Map.update(:v_idx, 0, fn idx -> idx + 1 end)

     # ".111"
     # ".@.."
      p2 in value_chars and p1 not in inv_char_state ->
        # Logger.debug("3")
        Map.update(state, :entries, [], fn entries -> entries ++ [Map.get(state, :v_idx)] end)
        |> Map.put(:char_state, 0)
        |> Map.put(:num_state, 1)

      # "@..."
      # "@..."
      p2 not in inv_char_state or p1 not in inv_char_state ->
        Map.put(state, :char_state, 1)

      # "111."
      # ".@.."
      p2 in value_chars and p1 in inv_char_state ->
        Map.put(state, :num_state, 1)

      # Reset increase
      Map.get(state, :num_state) == 1 and p2 not in value_chars and p1 in inv_char_state ->
        Map.put(state, :char_state, 0)
        |> Map.put(:num_state, 0)
        |> Map.update(:v_idx, 0, fn idx -> idx + 1 end)

      p2 in bool_reset and p1 in bool_reset ->
        Map.put(state, :char_state, 0)
        |> Map.put(:num_state, 0)

      p2 in bool_reset and p1 in value_chars ->
        Map.put(state, :char_state, 0)
        |> Map.put(:num_state, 0)

      true ->
        Logger.debug("#{p2} #{p1} : #{inspect state}")
        state
    end
  end

  # Aoc.solution_3(data|> String.split("\n", trim: true)) |> Aoc.construct_zipped() |> Stream.take(4) |> Enum.to_list |>  Aoc.build_hit_table
end
