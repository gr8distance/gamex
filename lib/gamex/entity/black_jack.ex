defmodule Gamex.Entity.BlackJack do
  require IEx

  alias Gamex.Entity.{Deck, Player, Card}

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
      {drawn_cards, deck} = Deck.draw(acc[:deck], 2)
      hand_updated = %{player | hand: drawn_cards}
      score_updated = %{hand_updated | score: calc_score(drawn_cards)}
      %{players: acc[:players] ++ [score_updated], deck: deck}
    end)
    |> new()
  end

  @spec play(t, Player.t(), atom) :: t
  def play(game, player, :hit) do
    {drawn_cards, deck} = Deck.draw(game.deck, 1)
    hand_updated = %{player | hand: player.hand ++ drawn_cards}
    score_updated = %{hand_updated | score: player.score + calc_score(drawn_cards)}
    new(%{players: merge_players(game.players, [score_updated]), deck: deck})
  end

  @spec merge_players([Player.t()], [Player.t()]) :: [Player.t()]
  defp merge_players(players, new_players) do
    players
    |> Enum.map(fn player ->
      new_players
      |> Enum.find(fn new_player -> new_player.name == player.name end)
      |> case do
        nil -> player
        new_player -> new_player
      end
    end)
  end

  # def play(game, player, :stand) do
  #   # TODO: ターンの概念をえたら次に順番を回す処理を書く
  # end

  @spec calc_score([Gamex.Entity.Card.t()]) :: integer
  def calc_score(cards) when is_list(cards) do
    cards
    |> Enum.reduce(0, fn card, acc ->
      acc + card_score(card)
    end)
  end

  @spec card_score(Gamex.Entity.Card.t()) :: integer
  defp card_score(%Card{number: number}) do
    cond do
      number == 1 -> 11
      number in 2..10 -> number
      number in 11..13 -> 10
      true -> IEx.pry()
    end
  end
end
