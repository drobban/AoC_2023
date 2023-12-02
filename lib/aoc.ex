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

  @path "./resources/adventofcode.com_2023_day_1_input.txt"
  def day1() do
    file_stream = File.stream!(@path, [], :line)
    solution_1(file_stream)
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
end
