defmodule Poker.Rules do
  @cardCount 5
  @rankOrder [:highcard, :pair, :twopair, :threeofkind, :straight, :flush, :fullhouse, :fourofkind, :straightflush]

  #  and len(cardList) == @cardCount
  def getRank(cardList) when is_list(cardList) do
      findRank(cardList)
  end

  def findRank(cardList) do
    {suiteMap, kindMap} = mapCards(cardList)

  end

  def mapCards(cardList) do
    Enum.reduce(cardList, {%{}, %{}}, fn [k|s], acc ->
      {
        Map.update(elem(acc, 0), s, 1, fn v -> v + 1 end),
        Map.update(elem(acc, 1), [k], 1, fn v -> v + 1 end)
      }
    end)
  end
end
