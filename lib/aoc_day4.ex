defmodule Aoc.Day4 do
  @path_day4 "./resources/adventofcode.com_2023_day_4_input.txt"
  def run() do
    file_stream = File.stream!(@path_day4, [], :line)
    solution(file_stream)
  end

  def solution(data) do
    data
    |> Enum.map(fn line -> line |> String.split(":") |> Enum.at(-1) end)
    |> Enum.map(fn line -> line |> String.split("|") end)
    |> Enum.map(fn [card, winners] ->
      {card
       |> String.split(~r/[^\d]/, trim: true)
       |> Enum.map(fn x ->
         String.to_integer(x)
       end),
       winners
       |> String.split(~r/[^\d]/, trim: true)
       |> Enum.map(fn x ->
         String.to_integer(x)
       end)}
    end)
    |> get_intersections()
    |> Enum.map(fn set -> calc_powers_of_size(set) end)
    |> Enum.sum()
  end

  def get_intersections(sets) do
    sets
    |> Enum.map(fn {card, winners} ->
      MapSet.intersection(MapSet.new(card), MapSet.new(winners))
    end)
  end

  def calc_powers_of_size(set) do
    if Enum.count(set) > 0, do: 2 ** (Enum.count(set) - 1), else: 0
  end
end
