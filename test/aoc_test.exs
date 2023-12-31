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

    assert Aoc.Day1.solution_1(String.split(data, "\n")) == 142
    assert Aoc.Day1.day1() == 55130
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

    assert Aoc.Day1.solution_1(String.split(data, "\n") |> Aoc.Day1.part_2_process()) == 281

    assert Aoc.Day1.solution_1(String.split(data2, "\n") |> Aoc.Day1.part_2_process()) == 1098
    assert Aoc.Day1.day1_part2() == 54985
  end

  test "day2" do
    data = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

    assert Aoc.Day2.solution_2(String.split(data, "\n"), %{
             "red" => 12,
             "green" => 13,
             "blue" => 14
           }) ==
             8

    assert Aoc.Day2.day2() == 2156
  end

  test "day2_part2" do
    data = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

    assert Aoc.Day2.solution_2_part2(String.split(data, "\n")) == 2286
    assert Aoc.Day2.day2_part2() == 66909
  end

  test "day3_part1" do
    data = "467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598.."

    data2 =
      "....668.484...............*............875.................*.........*....................227...*..908.............215......*.......270.....
             .......*......771..........318....883......881...........655.@26..130..799.......876..91......28...........699.........807...510............
             .............-........391*.........*.......+......903..................*.....379.*....@...........713........#............*.................
             ..........+................196..230...........411....*965..682.......873....$.....916....755....&..=.....................296......+958.983..
             ...*.....718.......279........%...............................*.271.............@.......*......932.......621..637.843..................*....
             ..59..........%2...........................................400...*...142.870...746......256..........865*...........%...=.....%...409...761."

    assert Aoc.Day3.solution_3(data |> String.split("\n", trim: true)) == 4361
    assert Aoc.Day3.solution_3(data2 |> String.split("\n", trim: true)) == 23354
    assert Aoc.Day3.day3() == 553_825
  end

  test "day4_part1" do
    data = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"

    assert Aoc.Day4.solution(data |> String.split("\n", trim: true)) == 13
    assert Aoc.Day4.run() == 25183
  end
end
