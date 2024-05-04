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

  alias Gamex.Entity.Player
  alias Gamex.Entity.BlackJack, as: BJ

  def start do
    players = [
      Player.new("alice"),
      Player.new("bob")
    ]

    game =
      BJ.new(players)
      |> BJ.start_game()

    alice = game.players |> List.first()
    ug = BJ.play(game, alice, :hit)
  end
end
