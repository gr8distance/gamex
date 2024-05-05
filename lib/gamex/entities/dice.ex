defmodule Gamex.Entities.Dice do
  def roll(), do: :rand.uniform(6)

  def roll(n) do
    1..n
    |> Enum.map(fn _ -> roll() end)
  end
end
