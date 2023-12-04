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

  # Aoc.solution_3(data|> String.split("\n", trim: true)) |> Aoc.construct_zipped() |> Stream.take(4) |> Enum.to_list |>  Aoc.build_hit_table
end
