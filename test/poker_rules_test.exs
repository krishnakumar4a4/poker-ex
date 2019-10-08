defmodule PokerRulesTest do
  use ExUnit.Case
  doctest Poker.Rules

  test "mapCards based on list of cards" do
    assert map_size(elem(Poker.Rules.mapCards(['2C','2H','3S','4D','JH']), 0)) == 4
    assert map_size(elem(Poker.Rules.mapCards(['2C','2H','3H','4D','JH']), 0)) == 3
    assert Map.get(elem(Poker.Rules.mapCards(['2C','2H','3H','4D','JH']), 0), 'H') == 3
    assert Map.get(elem(Poker.Rules.mapCards(['2C','2H','3H','4D','JH']), 0), 'C') == 1

    assert map_size(elem(Poker.Rules.mapCards(['5C','2H','3S','4D','JH']), 1)) == 5
    assert map_size(elem(Poker.Rules.mapCards(['TC','2H','3S','JD','JH']), 1)) == 4
    assert Map.get(elem(Poker.Rules.mapCards(['TC','2H','3H','4D','JH']), 1), 'T') == 1
    assert Map.get(elem(Poker.Rules.mapCards(['JC','2H','3H','4D','JH']), 1), 'J') == 2
  end

  test "getRank checks" do
    assert Poker.Rules.getRank(['1C','2H','3S','4D','JH']) == {:invalidcards, ['1C']}
    assert Poker.Rules.getRank(['2C','2H','3S','4D']) == {:invalidhandsize, 4}
  end

  test "finding high card" do
    assert Poker.Rules.getRank(['5C','2H','3S','4D','JH']) == {:ok, {:highcard, %{'C' => 1, 'D' => 1, 'H' => 2, 'S' => 1}, %{'2' => 1, '3' => 1, '4' => 1, '5' => 1, 'J' => 1}}}
  end

  test "finding pair" do
    assert Poker.Rules.getRank(['2C','2H','3S','4D','JH']) == {:ok, {:pair, %{'C' => 1, 'D' => 1, 'H' => 2, 'S' => 1}, %{'2' => 2, '3' => 1, '4' => 1, 'J' => 1}}}
  end

  test "finding twopair" do
    assert Poker.Rules.getRank(['2C','2H','3S','3D','JH']) == {:ok, {:twopair, %{'C' => 1, 'D' => 1, 'H' => 2, 'S' => 1}, %{'2' => 2, '3' => 2, 'J' => 1}}}
  end

  test "finding threeofkind" do
    assert Poker.Rules.getRank(['2C','2H','2S','4D','JH']) == {:ok, {:threeofkind, %{'C' => 1, 'D' => 1, 'H' => 2, 'S' => 1}, %{'2' => 3, '4' => 1, 'J' => 1}}}
  end

  test "finding straight" do
    assert Poker.Rules.getRank(['TC','JH','QS','KD','AH']) == {:ok, {:straight, %{'C' => 1, 'D' => 1, 'H' => 2, 'S' => 1}, %{'A' => 1, 'J' => 1, 'K' => 1, 'Q' => 1, 'T' => 1}}}
    assert Poker.Rules.getRank(['8C','5H','4S','6D','7H']) == {:ok, {:straight, %{'C' => 1, 'D' => 1, 'H' => 2, 'S' => 1}, %{'4' => 1, '5' => 1, '6' => 1, '7' => 1, '8' => 1}}}
  end

  test "finding flush" do
    assert Poker.Rules.getRank(['2C','JC','3C','KC','JC']) == {:ok, {:flush, %{'C' => 5}, %{'2' => 1, '3' => 1, 'J' => 2, 'K' => 1}}}
  end

  test "finding fullhouse" do
    assert Poker.Rules.getRank(['2C','2H','3S','3D','3H']) == {:ok, {:fullhouse, %{'C' => 1, 'D' => 1, 'H' => 2, 'S' => 1}, %{'2' => 2, '3' => 3}}}
  end

  test "finding fourofkind" do
    assert Poker.Rules.getRank(['2C','2H','2S','2D','JH']) == {:ok, {:fourofkind, %{'C' => 1, 'D' => 1, 'H' => 2, 'S' => 1}, %{'2' => 4, 'J' => 1}}}
  end

  test "finding straightflush" do
    assert Poker.Rules.getRank(['6H','3H','4H','2H','5H']) == {:ok, {:straightflush, %{'H' => 5}, %{'2' => 1, '3' => 1, '4' => 1, '5' => 1, '6' => 1}}}
  end

  test "compareRanks" do
    assert Poker.Rules.compareRanks(:straight, :flush) == -1
    assert Poker.Rules.compareRanks(:highcard, :straightflush) == -8
    assert Poker.Rules.compareRanks(:threeofkind, :twopair) == 1
  end

  test "compareStraights" do
    assert Poker.Rules.compareStraights(%{'2' => 1, '3' => 1, '4' => 1, '5' => 1, '6' => 1}, %{'3' => 1, '4' => 1, '5' => 1, '6' => 1, '7' => 1}) == {:winner, 2, '7'}
    assert Poker.Rules.compareStraights(%{'T' => 1, 'J' => 1, 'Q' => 1, 'A' => 1, 'K' => 1}, %{'3' => 1, '4' => 1, '5' => 1, '6' => 1, '7' => 1}) == {:winner, 1, 'A'}
    assert Poker.Rules.compareStraights(%{'T' => 1, 'J' => 1, 'Q' => 1, 'A' => 1, 'K' => 1}, %{'J' => 1, 'T' => 1, 'Q' => 1, 'A' => 1, 'K' => 1}) == :tie
  end

  test "compareFourOfKinds" do
    assert Poker.Rules.compareNOfKinds(4, %{'2' => 4, '4' => 1}, %{'3' => 4, '4' => 1}) == {:winner, 2, '3'}
    assert Poker.Rules.compareNOfKinds(4, %{'3' => 4, '4' => 1}, %{'3' => 4, '4' => 1}) == :tie
    assert Poker.Rules.compareNOfKinds(4, %{'3' => 4, 'T' => 1}, %{'3' => 4, '2' => 1}) == {:winner, 1, 'T'}
  end

  test "compareThreeOfKinds" do
    assert Poker.Rules.compareNOfKinds(3, %{'2' => 3, '4' => 1, '5' => 1}, %{'3' => 3, '4' => 1, '5' => 1}) == {:winner, 2, '3'}
    assert Poker.Rules.compareNOfKinds(3, %{'3' => 3, '4' => 1, '5' => 1}, %{'3' => 3, '4' => 1, '5' => 1}) == :tie
    assert Poker.Rules.compareNOfKinds(3, %{'3' => 3, '5' => 1, 'T' => 1}, %{'3' => 3, '2' => 1, '5' => 1}) == {:winner, 1, 'T'}
  end

  test "compareFullHouses" do
    assert Poker.Rules.compareFullHouses(%{'2' => 2, '4' => 3}, %{'A' => 2, 'Q' => 3}) == {:winner, 2, 'Q'}
    assert Poker.Rules.compareFullHouses(%{'A' => 2, 'Q' => 3}, %{'A' => 2, 'Q' => 3}) == :tie
    assert Poker.Rules.compareFullHouses(%{'A' => 2, 'K' => 3}, %{'A' => 2, 'Q' => 3}) == {:winner, 1, 'K'}
  end

  test "compareTwoPairs" do
    assert Poker.Rules.compareTwoPairs(%{'2' => 2, '4' => 2, 'T' => 1}, %{'3' => 2, '4' => 2, 'T' => 1}) == {:winner, 2, '3'}
    assert Poker.Rules.compareTwoPairs(%{'3' => 2, '4' => 2, 'T' => 1}, %{'3' => 2, '4' => 2, 'T' => 1}) == :tie
    assert Poker.Rules.compareTwoPairs(%{'T' => 2, '4' => 2, 'K' => 1}, %{'3' => 2, '5' => 2, 'K' => 1}) == {:winner, 1, 'T'}
    assert Poker.Rules.compareTwoPairs(%{'T' => 2, '4' => 2, 'Q' => 1}, %{'T' => 2, '4' => 2, 'K' => 1}) == {:winner, 2, 'K'}
  end

  test "comparePairs" do
    assert Poker.Rules.compareNOfKinds(2, %{'2' => 2, '4' => 1, 'T' => 1, '5' => 1}, %{'3' => 2, '4' => 1, 'T' => 1, '5' => 1}) == {:winner, 2, '3'}
    assert Poker.Rules.compareNOfKinds(2, %{'3' => 2, '4' => 1, 'T' => 1, '5' => 1}, %{'3' => 2, '4' => 1, 'T' => 1, '5' => 1}) == :tie
    assert Poker.Rules.compareNOfKinds(2, %{'3' => 2, '5' => 1, 'J' => 1, 'T' => 1}, %{'3' => 2, '2' => 1, '5' => 1, '6' => 1}) == {:winner, 1, 'J'}
  end

  test "compareHighcards" do
    assert Poker.Rules.compareHighcards(%{'2' => 1, '4' => 1, '5' => 1, '6' => 1, 'T' => 1}, %{'3' => 1, '4' => 1, 'T' => 1, '5' => 1, 'K' => 1}) == {:winner, 2, 'K'}
    assert Poker.Rules.compareHighcards(%{'3' => 1, '4' => 1, '5' => 1, '6' => 1, 'T' => 1}, %{'3' => 1, '4' => 1, 'T' => 1, '5' => 1, '6' => 1}) == :tie
    assert Poker.Rules.compareHighcards(%{'K' => 1, 'Q' => 1, '5' => 1, '6' => 1, 'T' => 1}, %{'3' => 1, '4' => 1, 'T' => 1, '5' => 1, 'K' => 1}) == {:winner, 1, 'Q'}
  end
end
