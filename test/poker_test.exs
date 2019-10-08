defmodule PokerTest do
  use ExUnit.Case
  doctest Poker

  test "publishWinner" do
    assertFunc = &(assert &1 == "Black is winner - #{:flush}: #{'T'}")
    Poker.publishWinner(:flush, {:winner, 1, 'T'}, assertFunc)
    assertFunc = &(assert &1 == "White is winner - #{:flush}: #{'T'}")
    Poker.publishWinner(:flush, {:winner, 2, 'T'}, assertFunc)
    assertFunc = &(assert &1 == "#{:tie}")
    Poker.publishWinner(:flush, :tie, assertFunc)
  end
end
