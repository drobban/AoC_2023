defmodule Aoc.Day1 do
  @path_day1 "./resources/adventofcode.com_2023_day_1_input.txt"
  def day1() do
    file_stream = File.stream!(@path_day1, [], :line)
    solution_1(file_stream)
  end

  def day1_part2() do
    file_stream = File.stream!(@path_day1, [], :line)

    file_stream
    |> Aoc.Day1.part_2_process()
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
end
