defmodule Poker.Validate do
  def noOfPairs(_suiteMap, kindMap) do
    length(Enum.filter(kindMap, fn x -> elem(x,1) == 2 end))
  end

  def threeOfKind(_suiteMap, kindMap) do
    length(Enum.filter(kindMap, fn x -> elem(x,1) == 3 end)) > 0
  end

  def fourOfKind(_suiteMap, kindMap) do
    length(Enum.filter(kindMap, fn x -> elem(x,1) == 4 end)) > 0
  end

  def isFlush(suiteMap, _kindMap) do
    map_size(suiteMap) == 1
  end

  @doc """
  isStraight check
  """
  def isStraight(_suiteMap, kindMap) do
    cond do
      map_size(kindMap) == 5 ->
        sortedKindList = Enum.map(kindMap, fn x -> elem(x,0) end) |> Poker.Suite.sortKinds
        checkStraight(nil, sortedKindList)
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
