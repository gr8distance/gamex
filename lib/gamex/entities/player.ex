defmodule Gamex.Entities.Player do
  alias Gamex.Entities.Card
  @type t :: %__MODULE__{name: String.t(), hand: [Card.t()], score: integer}
  defstruct name: "", hand: [], score: 0

  @spec new(String.t()) :: t()
  def new(name) do
    new(name, [], 0)
  end

  @spec new(String.t(), [Card.t()], integer) :: t()
  def new(name, hand, score) do
    %__MODULE__{
      name: name,
      hand: hand,
      score: score
    }
  end
end
