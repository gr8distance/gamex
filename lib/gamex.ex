defmodule Gamex do
  require IEx

  @moduledoc """
  Documentation for `Gamex`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Gamex.hello()
      :world

  """
  def hello do
    :world
  end

  alias Gamex.Entities.Player
  # alias Gamex.Entities.BlackJack, as: BJ
  alias Gamex.Entities.Chinchiro

  def start do
    players = [
      Player.new("alice", 5000),
      Player.new("bob", 5000)
    ]

    a =
      players
      |> Gamex.UseCases.Chinchiro.GameStarter.execute()
      |> Gamex.UseCases.Chinchiro.Judger.execute()
      |> Gamex.UseCases.Chinchiro.RewardDistributor.execute()

    IEx.pry()
  end
end
