defmodule Gamex.UseCases.Chinchiro.GameStarter do
  alias Gamex.Entities.Player
  alias Gamex.Entities.Chinchiro

  @spec execute([Player.t()]) :: Chinchiro.t()
  def execute(players) do
    players
    |> Chinchiro.new()
    |> Chinchiro.start_game()
  end
end
