defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "greets the world" do
    assert Aoc.hello() == :world
  end


  test "day1" do
    data = "1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet"

    assert Aoc.solution_1(String.split(data, "\n")) == 142
    assert Aoc.day1() == 55130
  end

  test "day2" do
    data = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

    assert Aoc.solution_2(String.split(data, "\n"), %{"red" => 12, "green" => 13, "blue" => 14}) == 8
    assert Aoc.day2() == 2156
  end
end
