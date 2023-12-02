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
  end
end
