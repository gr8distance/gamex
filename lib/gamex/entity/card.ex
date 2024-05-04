defmodule Gamex.Entity.Card do
  @type t :: %__MODULE__{number: integer, suit: String.t()}
  defstruct number: 1, suit: ""

  @spec new(integer, String.t()) :: t()
  def new(number, suit) do
    %__MODULE__{number: number, suit: suit}
  end
end
