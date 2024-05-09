defmodule Gamex.UseCases.Chinchiro.Judger do
  alias Gamex.Entities.Player
  alias Gamex.Entities.Chinchiro

  @type t :: %{winners: [Player.t()], loosers: [Player.t()], draws: [Player.t()]}
  defstruct winners: [], loosers: [], draws: []

  @spec execute(Chinchiro.t()) :: t
  def execute(chinchiro) do
    %__MODULE__{
      draws: Chinchiro.extract_draws(chinchiro),
      winners: Chinchiro.extract_winners(chinchiro),
      loosers: Chinchiro.extract_loosers(chinchiro)
    }
  end
end
