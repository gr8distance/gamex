defmodule Gamex.UseCases.Chinchiro.RewardDistributor do
  alias Gamex.Entities.Player
  alias Gamex.Entities.Chinchiro
  alias Gamex.UseCases.Chinchiro.Judger

  require IEx

  @spec execute(Judger.t()) :: [Player.t()]
  def execute(%{winners: winners, loosers: loosers, draws: []}) do
    price = loosers |> Enum.map(fn player -> player.bet end) |> Enum.sum()
    dist = price / length(winners)

    winners_players =
      winners
      |> Enum.map(fn player ->
        %{player | bet: 0, cache: player.cache + dist}
      end)

    loosers
    |> Enum.map(fn player -> %{player | bet: 0} end)
    |> Kernel.++(winners_players)
  end

  def execute(%{winners: [], loosers: [], draws: draws}) do
    draws
    |> Enum.map(fn player -> %{player | bet: 0} end)
  end
end
