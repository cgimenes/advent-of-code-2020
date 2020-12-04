defmodule Passport do
  def parse(passport) do
    Enum.reduce(passport, %{}, fn [f, v], acc -> Map.put(acc, f, v) end)
  end

  def valid?(passport) do
    contains_keys?(passport)
      and valid_byr?(passport)
      and valid_iyr?(passport)
      and valid_eyr?(passport)
      and valid_hgt?(passport)
      and valid_hcl?(passport)
      and valid_ecl?(passport)
      and valid_pid?(passport)
  end

  defp valid_byr?(passport) do
    byr = Map.get(passport, "byr")
    {intVal, _} = Integer.parse(byr)
    String.match?(byr, ~r/[0-9]{4}/) and intVal >= 1920 and intVal <= 2002
  end

  defp valid_iyr?(passport) do
    iyr = Map.get(passport, "iyr")
    {intVal, _} = Integer.parse(iyr)
    String.match?(iyr, ~r/[0-9]{4}/) and intVal >= 2010 and intVal <= 2020
  end

  defp valid_eyr?(passport) do
    eyr = Map.get(passport, "eyr")
    {intVal, _} = Integer.parse(eyr)
    String.match?(eyr, ~r/[0-9]{4}/) and intVal >= 2020 and intVal <= 2030
  end

  defp valid_hgt?(passport) do
    hgt = Map.get(passport, "hgt")
    {intVal, strVal} = Integer.parse(hgt)
    if String.match?(hgt, ~r/[0-9]{2,3}(cm|in)/) do
      case strVal do
        "cm" -> intVal >= 150 and intVal <= 193
        "in" -> intVal >= 59 and intVal <= 76
      end
    else
      false
    end
  end

  defp valid_hcl?(passport) do
    String.match?(Map.get(passport, "hcl"), ~r/#[0-9a-f]{6}/)
  end

  defp valid_ecl?(passport) do
    Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], Map.get(passport, "ecl"))
  end

  defp valid_pid?(passport) do
    String.length(Map.get(passport, "pid")) === 9
  end

  def contains_keys?(passport) do
    Map.has_key?(passport, "byr")
      and Map.has_key?(passport, "iyr")
      and Map.has_key?(passport, "eyr")
      and Map.has_key?(passport, "hgt")
      and Map.has_key?(passport, "hcl")
      and Map.has_key?(passport, "ecl")
      and Map.has_key?(passport, "pid")
  end
end

passports = File.read("input")
  |> elem(1)
  |> String.replace("\n", " ")
  |> String.split("  ")
  |> Enum.map(fn x -> String.split(x, " ") end)
  |> Enum.map(fn x -> Enum.map(x, fn x -> String.split(x, ":") end) end)
  |> Enum.map(&Passport.parse/1)

answer_1 = passports
  |> Enum.count(&Passport.contains_keys?/1)

answer_2 = passports
  |> Enum.count(&Passport.valid?/1)

IO.puts "Part 1: #{answer_1}"
IO.puts "Part 2: #{answer_2}"
