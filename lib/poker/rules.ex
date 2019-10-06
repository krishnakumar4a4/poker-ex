defmodule Poker.Rules do
  require Poker.Validate

  @cardCount 5
  @rankOrder [:highcard, :pair, :twopair, :threeofkind, :straight, :flush, :fullhouse, :fourofkind, :straightflush]

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
        :straightflush
      fourOfKind(suiteMap, kindMap) ->
        :fourofkind
      threeOfKind(suiteMap, kindMap) and noOfPairs(suiteMap, kindMap) == 1 ->
        :fullhouse
      isFlush(suiteMap, kindMap) ->
        :flush
      isStraight(suiteMap, kindMap) ->
        :straight
      threeOfKind(suiteMap, kindMap) ->
        :threeofkind
      noOfPairs(suiteMap, kindMap) == 2 ->
        :twopair
      noOfPairs(suiteMap, kindMap) == 1 ->
        :pair
      true ->
        :highcard
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
end
