defmodule PokerValidateTest do
  use ExUnit.Case
  doctest Poker.Validate

  test "checkStraight" do
    assert Poker.Validate.isStraight(%{}, %{'6'=>1, '2' => 1, '3' => 1, '4' => 1, '5' => 1}) == true
    assert Poker.Validate.isStraight(%{}, %{'7'=>1, '2' => 1, '3' => 1, '4' => 1, '6' => 1}) == false
  end
end
