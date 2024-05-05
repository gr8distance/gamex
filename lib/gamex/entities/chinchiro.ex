defmodule Gamex.Entities.Chinchiro do
  use Gamex.Entities.Interfaces.Game

  alias Gamex.Entities.Dice
  alias Gamex.Entities.Player

  require IEx

  @type t :: %__MODULE__{players: [Player.t()]}
  defstruct players: []

  @spec new([Player.t()]) :: t
  def new(players) do
    %__MODULE__{players: players}
  end

  @spec start_game(t) :: t
  def start_game(game) do
    game.players
    |> Enum.map(fn player ->
      %{player | hand: roll(3)}
    end)
    |> Enum.map(fn player ->
      %{player | score: calc_score(player.hand |> Enum.sort())}
    end)
    |> new()
  end

  @spec roll(integer) :: [integer]
  defp roll(retry) do
    if retry <= 0 do
      raise "retry must be greater than 0"
    else
      roll(retry - 1, Dice.roll(3))
    end
  end

  @spec roll(integer, [integer]) :: [integer]
  defp roll(0, acm), do: acm

  defp roll(retry, acm) do
    if calc_score(Enum.sort(acm)) == 0 do
      roll(retry - 1, Dice.roll(3))
    else
      acm
    end
  end

  @spec play(t, Player.t(), :roll) :: t
  def play(game, player, :roll) do
    hand_updated = %{player | hand: Dice.roll(3)}
    score_updated = %{hand_updated | score: calc_score(hand_updated.hand |> Enum.sort())}
    new(merge_players(game.players, [score_updated]))
  end

  @spec calc_score([integer]) :: integer
  def calc_score([1, 2, 3]), do: -2
  def calc_score([4, 5, 6]), do: 7
  # NOTE: ピンゾロ(1のゾロ目)は6より強い == 最強
  def calc_score([1, 1, 1]), do: 100
  def calc_score([2, 2, 2]), do: 20
  def calc_score([3, 3, 3]), do: 30
  def calc_score([4, 4, 4]), do: 40
  def calc_score([5, 5, 5]), do: 50
  def calc_score([6, 6, 6]), do: 60

  def calc_score(rolles) do
    rolles
    |> Enum.group_by(fn i -> i end)
    |> fightable?()
    |> extract_point()
  end

  @spec extract_point({boolean, map}) :: integer
  defp extract_point({false, _}), do: 0

  defp extract_point({true, grouped}) do
    grouped
    |> Enum.reject(fn {_, v} -> v |> length() == 2 end)
    |> Enum.into(%{})
    |> Map.keys()
    |> List.first()
  end

  # NOTE: 役がある場合 == 勝負可能
  @spec fightable?(map) :: {boolean, map}
  defp fightable?(grouped) do
    result =
      grouped
      |> Map.keys()
      |> length()
      |> Kernel.==(2)

    {result, grouped}
  end
end
