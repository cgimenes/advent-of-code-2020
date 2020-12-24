defmodule Bus do
  def parse(id) do
    case Integer.parse id do
      :error -> id
      {r, _} -> r
    end
  end

# BRUTE FORCE METHOD FOR PART 2
  #  def check(timestamp, restrictions, mr_index) do
  #    restrictions
  #    |> Enum.map(fn x -> rem(timestamp + (mr_index - elem(x, 0)) * -1, elem(x, 1)) == 0 end)
  #    |> Enum.reduce(true, fn x, acc -> x and acc end)
  #  end

  def find_y(bm, m) do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.filter(&(rem(bm * &1, m) == 1))
    |> Enum.take(1)
    |> List.first
  end

  def chinese(restrictions) do
    big_m = restrictions
    |> Enum.map(fn {_, m} -> m end)
    |> Enum.reduce(&Kernel.*/2)

    restrictions
    |> Enum.map(fn {a, m} -> {a, m, div(big_m, m)} end)
    |> Enum.map(fn {a, m, bm} -> a * bm * find_y(bm, m) end)
    |> Enum.sum
    |> Integer.mod(big_m)
  end
end

data = File.read("input")
|> elem(1)
|> String.split("\n")

timestamp = data
|> List.first
|> Integer.parse
|> elem(0)

id_list = data
|> List.last
|> String.split(",")
|> Enum.map(&Bus.parse/1)

buses = id_list
|> Enum.filter(&(&1 != "x"))

next_buses = buses
|> Enum.map(fn x -> {x, x * (div(timestamp, x) + 1)} end)

earliest_bus = next_buses
|> Enum.min_by(&(elem(&1, 1)))

restrictions = Stream.iterate(0, &(&1 + 1))
|> Stream.zip(id_list)
|> Stream.filter(fn {_, x} -> x != "x" end)
|> Enum.map(fn {a, b} -> {b - a, b} end)

answer_1 = (elem(earliest_bus, 1) - timestamp) * elem(earliest_bus, 0)

answer_2 = Bus.chinese restrictions

IO.puts "Part 1: #{answer_1}"
IO.puts "Part 2: #{answer_2}"

# BRUTE FORCE METHOD FOR PART 2
  #max_restriction = restrictions
  #|> Enum.max_by(&(elem(&1, 1)))
  #{mr_index, mr_id} = max_restriction
  #restrictions = restrictions
  #|> List.delete(max_restriction)
  #answer_2 = Stream.iterate(mr_id, &(&1 + mr_id))
  #|> Stream.filter(&(Bus.check(&1, restrictions, mr_index)))
  #|> Enum.take(1)
  #|> List.first
  #|> Kernel.-(mr_index)
