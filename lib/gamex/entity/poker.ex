defmodule Gamex.Entity.Poker do
  alias Gamex.Entity.{Deck, Player}

  @type t :: %__MODULE__{players: [Player.t()], deck: Deck.t()}
  defstruct players: [], deck: nil

  @spec new([Player.t()], Deck.t()) :: t
  def new(players, deck) do
    %__MODULE__{
      players: players,
      deck: Deck.shuffle(deck)
    }
  end

  @spec new(%{players: [Player.t()], deck: Deck.t()}) :: t
  def new(%{players: players, deck: deck}), do: new(players, deck)

  @spec new([Player.t()]) :: t
  def new(players) do
    new(players, Deck.new())
  end

  require IEx

  @spec start_game(t) :: t
  def start_game(game) do
    game.players
    |> Enum.reduce(%{players: [], deck: game.deck}, fn player, acc ->
      {drawn_cards, deck} = Deck.draw(acc[:deck], 5)
      hand_updated = %{player | hand: drawn_cards}
      score_updated = %{hand_updated | score: calc_score(drawn_cards)}
      %{players: acc[:players] ++ [score_updated], deck: deck}
    end)
    |> new()
  end

  @spec calc_score([Gamex.Entity.Card.t()]) :: integer
  def calc_score(cards) do
    cond do
      royal_straight_flush?(cards) -> 9
      straight_flush?(cards) -> 8
      four_card?(cards) -> 7
      full_house?(cards) -> 6
      flush?(cards) -> 5
      straight?(cards) -> 4
      tree_card?(cards) -> 3
      two_pair?(cards) -> 2
      one_pair?(cards) -> 1
      true -> 0
    end
  end

  @spec royal_straight_flush?([Gamex.Entity.Card.t()]) :: boolean
  def royal_straight_flush?(cards) do
    straight_flush?(cards) &&
      cards
      |> Enum.map(& &1.number)
      |> Enum.sort()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.filter(fn [a, b] -> b - a == 1 end)
      |> length() == 4
  end

  @spec straight_flush?([Gamex.Entity.Card.t()]) :: boolean
  def straight_flush?(cards) do
    straight?(cards) && flush?(cards)
  end

  @spec four_card?([Gamex.Entity.Card.t()]) :: boolean
  def four_card?(cards) do
    cards
    |> Enum.group_by(& &1.number)
    |> Enum.filter(fn {_value, cards} -> length(cards) == 4 end)
    |> length() == 1
  end

  @spec full_house?([Gamex.Entity.Card.t()]) :: boolean
  def full_house?(cards) do
    cards
    |> Enum.group_by(& &1.number)
    |> Enum.filter(fn {_value, cards} -> length(cards) == 3 end)
    |> length() == 1
  end

  @spec flush?([Gamex.Entity.Card.t()]) :: boolean
  def flush?(cards) do
    cards
    |> Enum.map(& &1.suit)
    |> Enum.uniq()
    |> length() == 1
  end

  @spec straight?([Gamex.Entity.Card.t()]) :: boolean
  def straight?(cards) do
    cards
    |> Enum.map(& &1.number)
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [a, b] -> b - a == 1 end)
    |> length() == 4
  end

  @spec tree_card?([Gamex.Entity.Card.t()]) :: boolean
  def tree_card?(cards) do
    cards
    |> Enum.group_by(& &1.number)
    |> Enum.filter(fn {_value, cards} -> length(cards) == 3 end)
    |> length() == 1
  end

  @spec one_pair?([Gamex.Entity.Card.t()]) :: boolean
  def two_pair?(cards) do
    cards
    |> Enum.group_by(& &1.number)
    |> Enum.filter(fn {_value, cards} -> length(cards) == 2 end)
    |> length() == 2
  end

  @spec one_pair?([Gamex.Entity.Card.t()]) :: boolean
  defp one_pair?(cards) do
    cards
    |> Enum.group_by(& &1.number)
    |> Enum.filter(fn {_value, cards} -> length(cards) == 2 end)
    |> length() == 1
  end
end
