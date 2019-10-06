defmodule PokerRulesTest do
  use ExUnit.Case
  doctest Poker.Rules

  test "mapCards based on list of cards" do
    assert map_size(elem(Poker.Rules.mapCards(['1C','2H','3S','4D','JH']), 0)) == 4
    assert map_size(elem(Poker.Rules.mapCards(['1C','2H','3H','4D','JH']), 0)) == 3
    assert Map.get(elem(Poker.Rules.mapCards(['1C','2H','3H','4D','JH']), 0), 'H') == 3
    assert Map.get(elem(Poker.Rules.mapCards(['1C','2H','3H','4D','JH']), 0), 'C') == 1

    assert map_size(elem(Poker.Rules.mapCards(['1C','2H','3S','4D','JH']), 1)) == 5
    assert map_size(elem(Poker.Rules.mapCards(['1C','2H','3S','JD','JH']), 1)) == 4
    assert Map.get(elem(Poker.Rules.mapCards(['1C','2H','3H','4D','JH']), 1), '1') == 1
    assert Map.get(elem(Poker.Rules.mapCards(['JC','2H','3H','4D','JH']), 1), 'J') == 2
  end
end
