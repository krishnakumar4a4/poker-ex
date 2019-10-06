defmodule Poker.Validate do
  @doc """
  isStraight check
  """
  def isStraight(_suiteMap, kindMap) do
    cond do
      map_size(kindMap) == 5 ->
        kindList = Map.keys(kindMap) |> Enum.sort
        checkStraight(nil, kindList)
      true ->
        false
    end
  end

  defp checkStraight(_, []) do
    true
  end

  defp checkStraight(prev, [k|rem]) do
    cond do
      prev == nil ->
        checkStraight(k, rem)
      prev != nil ->
        if Poker.Suite.compareKinds(prev, k) == 1 do
          checkStraight(k, rem)
        else
          false
        end
    end
  end
end
