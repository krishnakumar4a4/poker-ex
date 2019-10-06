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
    assert Poker.Rules.getRank(['5C','2H','3S','4D','JH']) == {:ok, :highcard}
  end

  test "finding pair" do
    assert Poker.Rules.getRank(['2C','2H','3S','4D','JH']) == {:ok, :pair}
  end

  test "finding twopair" do
    assert Poker.Rules.getRank(['2C','2H','3S','3D','JH']) == {:ok, :twopair}
  end

  test "finding threeofkind" do
    assert Poker.Rules.getRank(['2C','2H','2S','4D','JH']) == {:ok, :threeofkind}
  end

  test "finding straight" do
    assert Poker.Rules.getRank(['TC','JH','QS','KD','AH']) == {:ok, :straight}
    assert Poker.Rules.getRank(['8C','5H','4S','6D','7H']) == {:ok, :straight}
  end

  test "finding flush" do
    assert Poker.Rules.getRank(['2C','JC','3C','KC','JC']) == {:ok, :flush}
  end

  test "finding fullhouse" do
    assert Poker.Rules.getRank(['2C','2H','3S','3D','3H']) == {:ok, :fullhouse}
  end

  test "finding fourofkind" do
    assert Poker.Rules.getRank(['2C','2H','2S','2D','JH']) == {:ok, :fourofkind}
  end

  test "finding straightflush" do
    assert Poker.Rules.getRank(['6H','3H','4H','2H','5H']) == {:ok, :straightflush}
  end
end
