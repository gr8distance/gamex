defmodule Gamex.Entities.GameInterfaces do
  alias Gamex.Entities.Player

  @callback new(players :: [Player.t()]) :: term
  @callback start_game(game :: term) :: term
  @callback play(term, Player.t(), atom) :: term

  defmacro __using__(_) do
    quote do
      @behaviour Gamex.Entities.GameInterfaces
    end
  end
end
