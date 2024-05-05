defmodule Gamex.Entities.Interfaces.Game do
  alias Gamex.Entities.Player

  @callback new(players :: [Player.t()]) :: term
  @callback start_game(game :: term) :: term
  @callback play(term, Player.t(), atom) :: term

  defmacro __using__(_) do
    quote do
      @behaviour Gamex.Entities.Interfaces.Game

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
    end
  end
end
