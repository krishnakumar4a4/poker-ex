defmodule PokerSuiteTest do
  use ExUnit.Case
  doctest Poker.Suite

  test "compare cards with invalid suites" do
    assert Poker.Suite.compare('2A','2C') == nil
    assert Poker.Suite.compare('2A','2B') == nil
  end

  test "compare cards suites dont match" do
    assert Poker.Suite.compare('2S','2D') == nil
  end

  test "compare cards of same suite and same value" do
    assert Poker.Suite.compare('2C','2C') == 0
  end

  test "compare cards of same suite and first is greater than second" do
    assert Poker.Suite.compare('3C','2C') == 1
    assert Poker.Suite.compare('TC','2C') == 8
    assert Poker.Suite.compare('AC','2C') == 12
  end

  test "compare cards of same suite and first is lesser than second" do
    assert Poker.Suite.compare('2C','5C') == -3
    assert Poker.Suite.compare('2C','QC') == -10
    assert Poker.Suite.compare('2C','AC') == -12
  end

  test "isValidCard" do
    assert Poker.Suite.isValidCard('2A') == false
    assert Poker.Suite.isValidCard('2AA') == false
    assert Poker.Suite.isValidCard('MA') == false
    assert Poker.Suite.isValidCard('TH') == true
  end

  test "sortKinds" do
    # high to low sort
    assert Poker.Suite.sortKinds(['2','Q','J']) == ['Q','J','2']
    assert Poker.Suite.sortKinds(['A','6','3','T','2']) == ['A','T','6','3','2']
    assert Poker.Suite.sortKinds(['9','T','J','Q','K','A']) == ['A','K','Q','J','T','9']
  end

  test "compareKinds" do
    assert Poker.Suite.compareKinds('2','3') == -1
    assert Poker.Suite.compareKinds('A','T') == 4
    assert Poker.Suite.compareKinds('J','J') == 0
    assert Poker.Suite.compareKinds('1','J') == nil
  end
end
