defmodule Poker.Rules do
  require Poker.Validate

  @cardCount 5
  @rankOrder [:highcard, :pair, :twopair, :threeofkind, :straight, :flush, :fullhouse, :fourofkind, :straightflush]

  ###################
  def getRank(cardList) when is_list(cardList) do
    cond do
      length(cardList) != @cardCount ->
        {:invalidhandsize, length(cardList)}
      length(Enum.filter(cardList, &!Poker.Suite.isValidCard(&1)))>0 ->
        {:invalidcards, Enum.filter(cardList, &!Poker.Suite.isValidCard(&1))}
      true ->
        {:ok, findRank(cardList)}
    end
  end

  def findRank(cardList) do
    import Poker.Validate

    {suiteMap, kindMap} = mapCards(cardList)
    cond do
      isStraight(suiteMap, kindMap) and isFlush(suiteMap, kindMap) ->
        {:straightflush, suiteMap, kindMap}
      fourOfKind(suiteMap, kindMap) ->
        {:fourofkind, suiteMap, kindMap}
      threeOfKind(suiteMap, kindMap) and noOfPairs(suiteMap, kindMap) == 1 ->
        {:fullhouse, suiteMap, kindMap}
      isFlush(suiteMap, kindMap) ->
        {:flush, suiteMap, kindMap}
      isStraight(suiteMap, kindMap) ->
        {:straight, suiteMap, kindMap}
      threeOfKind(suiteMap, kindMap) ->
        {:threeofkind, suiteMap, kindMap}
      noOfPairs(suiteMap, kindMap) == 2 ->
        {:twopair, suiteMap, kindMap}
      noOfPairs(suiteMap, kindMap) == 1 ->
        {:pair, suiteMap, kindMap}
      true ->
        {:highcard, suiteMap, kindMap}
    end
  end

  def mapCards(cardList) do
    Enum.reduce(cardList, {%{}, %{}}, fn [k|s], acc ->
      {
        Map.update(elem(acc, 0), s, 1, fn v -> v + 1 end),
        Map.update(elem(acc, 1), [k], 1, fn v -> v + 1 end)
      }
    end)
  end

  #####################
  def compareRanks(r1, r2) when r1 in @rankOrder and r2 in @rankOrder do
    indexR1 = Enum.find_index(@rankOrder, &(&1 == r1))
    indexR2 = Enum.find_index(@rankOrder, &(&1 == r2))
    indexR1 - indexR2
  end

  #####################
  def compareStraightFlushes({_, _suiteMap1, kindMap1}, {_, _suiteMap2, kindMap2}) do
    # TODO: This can be simplified
    sortedKindList1 = Enum.map(kindMap1, fn x -> elem(x,0) end) |> Poker.Suite.sortKinds
    sortedKindList2 = Enum.map(kindMap2, fn x -> elem(x,0) end) |> Poker.Suite.sortKinds
    zippedKinds = Enum.zip(sortedKindList1, sortedKindList2)
    result(compareZips(zippedKinds))
  end

  def compareNOfKinds(n, {_, _suiteMap1, kindMap1}, {_, _suiteMap2, kindMap2}) do
    f1 = elem(Enum.filter(kindMap1, fn x -> elem(x,1) == n end) |> hd, 0)
    f2 = elem(Enum.filter(kindMap2, fn x -> elem(x,1) == n end) |> hd, 0)
    if f1 == f2 do
      sortedKindList1 = Enum.filter(kindMap1, fn x -> elem(x,1) == 1 end) |> Enum.map(fn x -> elem(x,0) end) |> Poker.Suite.sortKinds
      sortedKindList2 = Enum.filter(kindMap2, fn x -> elem(x,1) == 1 end) |> Enum.map(fn x -> elem(x,0) end) |> Poker.Suite.sortKinds
      zippedKinds = Enum.zip(sortedKindList1, sortedKindList2)
      result(compareZips(zippedKinds))
    else
      result({Poker.Suite.compareKinds(f1,f2), f1, f2})
    end
  end

  def compareFullHouses({_, _suiteMap1, kindMap1}, {_, _suiteMap2, kindMap2}) do
    f1 = elem(Enum.filter(kindMap1, fn x -> elem(x,1) == 3 end) |> hd, 0)
    f2 = elem(Enum.filter(kindMap2, fn x -> elem(x,1) == 3 end) |> hd, 0)
    if f1 == f2 do
      k1 = elem(Enum.filter(kindMap1, fn x -> elem(x,1) == 2 end) |> hd, 0)
      k2 = elem(Enum.filter(kindMap2, fn x -> elem(x,1) == 2 end) |> hd, 0)
      cond do
        k1 == k2 ->
          result(:tie)
        true ->
          result({Poker.Suite.compareKinds(k1,k2), k1, k2})
      end
    else
      result({Poker.Suite.compareKinds(f1,f2), f1, f2})
    end
  end

  def compareTwoPairs({_, _suiteMap1, kindMap1}, {_, _suiteMap2, kindMap2}) do
    p1 = Enum.filter(kindMap1, fn x -> elem(x,1) == 2 end) |> Enum.map(fn x -> elem(x,0) end) |> Poker.Suite.sortKinds
    p2 = Enum.filter(kindMap2, fn x -> elem(x,1) == 2 end) |> Enum.map(fn x -> elem(x,0) end) |> Poker.Suite.sortKinds
    zippedKinds = Enum.zip(p1, p2)
    case result(compareZips(zippedKinds)) do
      :tie ->
        k1 = elem(Enum.filter(kindMap1, fn x -> elem(x,1) == 1 end) |> hd, 0)
        k2 = elem(Enum.filter(kindMap2, fn x -> elem(x,1) == 1 end) |> hd, 0)
        cond do
          k1 == k2 ->
            result(:tie)
          true ->
            result({Poker.Suite.compareKinds(k1,k2), k1, k2})
        end
      res ->
        res
    end
  end

  def compareHighcards({_, _suiteMap1, kindMap1}, {_, _suiteMap2, kindMap2}) do
    sortedKindList1 = Enum.map(kindMap1, fn x -> elem(x,0) end) |> Poker.Suite.sortKinds
    sortedKindList2 = Enum.map(kindMap2, fn x -> elem(x,0) end) |> Poker.Suite.sortKinds
    zippedKinds = Enum.zip(sortedKindList1, sortedKindList2)
    result(compareZips(zippedKinds))
  end

  defp result(res) do
    case res do
      {diff, k1, k2} when diff > 0 ->
        {:winner, 1, k1}
      {diff, k1, k2} when diff < 0 ->
        {:winner, 2, k2}
      :tie ->
        :tie
    end
  end

  defp compareZips([]) do
    :tie
  end

  defp compareZips([{k1,k2}|rem]) do
    cond do
      k1 != k2 ->
        {Poker.Suite.compareKinds(k1,k2), k1, k2}
      true ->
        compareZips(rem)
    end
  end
end
