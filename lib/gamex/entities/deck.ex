defmodule Gamex.Entities.Deck do
  require IEx

  @type t :: %__MODULE__{cards: [Gamex.Entities.Card.t()]}
  defstruct cards: []

  @spec new() :: t
  def new() do
    [:hearts, :diamonds, :clubs, :spades]
    |> Enum.flat_map(fn suit ->
      1..13
      |> Enum.map(fn number ->
        Gamex.Entities.Card.new(number, suit)
      end)
    end)
    |> new()
  end

  @spec new([Gamex.Entities.Card.t()]) :: t
  def new(cards) do
    %__MODULE__{cards: cards}
  end

  @spec shuffle(t) :: t
  def shuffle(deck) do
    deck.cards
    |> Enum.shuffle()
    |> new()
  end

  @spec draw(t, integer) :: {[Gamex.Entities.Card.t()], t}
  def draw(deck, n) do
    {drawn_cards, new_deck} = Enum.split(deck.cards, n)
    {drawn_cards, new(new_deck)}
  end
end
