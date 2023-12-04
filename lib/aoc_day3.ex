defmodule Aoc.Day3 do
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
        |> Aoc.Day3.construct_zipped()
        |> Enum.to_list()
        |> Aoc.Day3.build_hit_table()
        |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k - 1, v) end),
        data
        |> Enum.map(fn line -> String.replace(line, "\n", "") end)
        |> Enum.map(fn line -> String.split(line, "", trim: true) end)
        |> Enum.to_list()
        |> Aoc.Day3.construct_zipped_rev()
        |> Enum.to_list()
        |> Aoc.Day3.build_hit_table()
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

    # hit_map
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
      Map.put(acc, idx, find_entries(lines))
    end)
  end

  def find_entries(cols) do
    cols
    |> Enum.with_index()
    |> Enum.reduce(%{num_state: 0, char_state: 0, v_idx: 0, entries: []}, fn {{p1, p2}, _idx},
                                                                             acc ->
      find_cond(acc, p2, p1)
    end)
  end

  def find_cond(state, p2, p1) do
    bool_reset = ["."]
    value_chars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    inv_char_state = bool_reset ++ value_chars

    num_state = Map.get(state, :num_state) == 1
    char_state = Map.get(state, :char_state) == 1
    p2_symbol = p2 not in inv_char_state
    p2_val = p2 in value_chars
    p2_reset = p2 in bool_reset
    p1_symbol = p1 not in inv_char_state

    case {num_state, char_state, p2_symbol, p2_val, p2_reset, p1_symbol} do
      {false, true, false, false, true, true} ->
        # "...."
        # "@@.."
        state
        |> Map.put(:char_state, 1)

      {true, false, false, false, true, false} ->
        # Increment :v_idx only scenarios
        # "1..."
        # "...."
        state |> Map.update(:v_idx, 0, fn i -> i + 1 end) |> Map.put(:num_state, 0)

      {true, true, false, false, true, false} ->
        # Increment :v_idx
        # ".111."
        # "...@1"
        state
        |> Map.update(:v_idx, 0, fn i -> i + 1 end)
        |> Map.put(:num_state, 0)
        |> Map.put(:char_state, 0)

      {true, false, true, false, false, _} ->
        # Increment :v_idx and store entry
        # ".111@"
        # "....@"
        state
        |> Map.update(:v_idx, 0, fn i -> i + 1 end)
        |> Map.put(:num_state, 0)
        |> Map.put(:char_state, 1)
        |> Map.update(:entries, [], fn c ->
          c ++ [Map.get(state, :v_idx)]
        end)

      {true, false, false, false, true, true} ->
        # Increment :v_idx and store entry
        # ".111."
        # "....@"
        state
        |> Map.update(:v_idx, 0, fn i -> i + 1 end)
        |> Map.put(:num_state, 0)
        |> Map.put(:char_state, 1)
        |> Map.update(:entries, [], fn c ->
          c ++ [Map.get(state, :v_idx)]
        end)

      {true, false, false, true, false, true} ->
        # store entry
        # ".111."
        # "...@."
        state
        |> Map.put(:num_state, 1)
        |> Map.put(:char_state, 1)
        |> Map.update(:entries, [], fn c ->
          c ++ [Map.get(state, :v_idx)]
        end)

      {false, true, false, true, false, true} ->
        # store entry
        # "@111."
        # "@@..."
        state
        |> Map.update(:v_idx, 0, fn i -> i + 1 end)
        |> Map.put(:num_state, 1)
        |> Map.put(:char_state, 1)
        |> Map.update(:entries, [], fn c ->
          c ++ [Map.get(state, :v_idx)]
        end)

      {false, true, false, true, false, false} ->
        # store entry
        # ".111."
        # "@...."
        state
        |> Map.put(:num_state, 1)
        |> Map.put(:char_state, 0)
        |> Map.update(:entries, [], fn c ->
          c ++ [Map.get(state, :v_idx)]
        end)

      {true, true, false, true, false, false} ->
        # store entry
        # "1111."
        # "@...."
        state
        |> Map.put(:num_state, 1)
        |> Map.put(:char_state, 0)
        |> Map.update(:entries, [], fn c ->
          c ++ [Map.get(state, :v_idx)]
        end)

      {false, false, false, true, false, true} ->
        # store entry
        # ".111."
        # "@...."
        state
        |> Map.put(:num_state, 1)
        |> Map.put(:char_state, 0)
        |> Map.update(:entries, [], fn c ->
          c ++ [Map.get(state, :v_idx)]
        end)

      {false, false, false, false, true, true} ->
        # "...."
        # ".@.."
        state
        |> Map.put(:char_state, 1)

      {false, false, true, false, false, false} ->
        # ".@.."
        # "...."
        state
        |> Map.put(:char_state, 1)

      {false, true, true, false, false, true} ->
        # "@@.."
        # ".@.."
        state
        |> Map.put(:char_state, 1)

      {false, true, false, false, true, false} ->
        # "...."
        # ".@.."
        state
        |> Map.put(:char_state, 0)

      {false, true, true, false, false, false} ->
        # ".@.."
        # "@..."
        state
        |> Map.put(:char_state, 0)

      {false, false, true, false, false, true} ->
        # ".@.."
        # ".@.."
        state
        |> Map.put(:char_state, 1)

      {_, false, false, true, false, false} ->
        # "..3."
        # "...."
        state
        |> Map.put(:num_state, 1)

      {false, false, false, false, true, false} ->
        # "...."
        # "...."
        state
    end
  end
end
