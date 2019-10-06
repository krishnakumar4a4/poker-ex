defmodule PokerValidateTest do
  use ExUnit.Case
  doctest Poker.Validate

  test "checkStraight" do
    assert Poker.Validate.isStraight(%{}, %{'6'=>1, '2' => 1, '3' => 1, '4' => 1, '5' => 1}) == true
    assert Poker.Validate.isStraight(%{}, %{'T'=>1, 'K' => 1, 'A' => 1, 'J' => 1, 'Q' => 1}) == true
    assert Poker.Validate.isStraight(%{}, %{'7'=>1, '2' => 1, '3' => 1, '4' => 1, '6' => 1}) == false
  end

  test "checkFlush" do
    assert Poker.Validate.isFlush(%{'C'=>1}, %{}) == true
    assert Poker.Validate.isFlush(%{'C'=>1, 'S' => 4}, %{}) == false
  end

  test "checkFourOfKind" do
    assert Poker.Validate.fourOfKind(%{}, %{'6'=>4, '2' => 1}) == true
    assert Poker.Validate.fourOfKind(%{}, %{'6'=>3, '2' => 2}) == false
  end

  test "checkthreeOfKind" do
    assert Poker.Validate.threeOfKind(%{}, %{'T'=>3, '2' => 1, '1' => 1}) == true
    assert Poker.Validate.threeOfKind(%{}, %{'6'=>1, '2' => 1, '3' => 1, '4' => 1, '5' => 1}) == false
  end

  test "noOfPairs" do
    assert Poker.Validate.noOfPairs(%{}, %{'T'=>2, '2' => 1, '1' => 1, '8' => 1}) == 1
    assert Poker.Validate.noOfPairs(%{}, %{'Q'=>2, '2' => 2, '3' => 1}) == 2
    assert Poker.Validate.noOfPairs(%{}, %{'6'=>1, '2' => 1, '3' => 1, '4' => 1, '5' => 1}) == 0
  end
end
