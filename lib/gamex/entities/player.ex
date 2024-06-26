defmodule Gamex.Entities.Player do
  alias Gamex.Entities.Card

  @type t :: %__MODULE__{
          name: String.t(),
          hand: [Card.t()],
          score: integer,
          bet: integer,
          cache: integer
        }
  defstruct name: "", hand: [], score: 0, bet: 0, cache: 0

  @spec new(String.t()) :: t()
  def new(name) do
    new(name, [], 0, 0)
  end

  @spec new(String.t(), integer) :: t()
  def new(name, bet) do
    new(name, [], 0, bet)
  end

  @spec new(String.t(), [Card.t()], integer, integer) :: t()
  def new(name, hand, score, bet) do
    %__MODULE__{
      name: name,
      hand: hand,
      score: score,
      bet: bet,
      cache: 0
    }
  end
end
