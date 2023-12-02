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

  test "day1_part2" do
    data = "two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen"

    data2 = "119one
    5lseven87nmxxqvhmn
    pphfmcfhxlsevensqdmtvtpvq1
    18eightfivefour
    three98
    4onephzhtq4qc5four
    26zglkpjvz3twoeight
    7mxkdrbpnk29
    ppeight15
    9jnprvtmscsixbbpsixfivecktgvdpf5
    lbftvcngvkvxf5cmmrqljjb471
    eight3knrvtwo
    one6pvbpkqkpdsixbv
    eight2onethree6eight
    5rztcbtfjkb2twoeight39hxppvpxqg
    8threemlllncmfourthree
    vhtsmncssixbmlpggvmlzdxbczgc1fxrgvsbhsrbs
    ninebnpv7575three
    4mthree"

    assert Aoc.solution_1(String.split(data, "\n") |> Aoc.part_2_process()) == 281

    assert Aoc.solution_1(String.split(data2, "\n") |> Aoc.part_2_process()) == 1098
    assert Aoc.day1_part2() == 54985
  end

  test "day2" do
    data = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

    assert Aoc.solution_2(String.split(data, "\n"), %{"red" => 12, "green" => 13, "blue" => 14}) ==
             8

    assert Aoc.day2() == 2156
  end

  test "day2_part2" do
    data = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

    assert Aoc.solution_2_part2(String.split(data, "\n")) == 2286
    assert Aoc.day2_part2() == 66909

  end
end
