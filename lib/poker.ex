defmodule Poker do
  @player1 "Black"
  @player2 "White"

  def start do
    readPlayersInput
  end

  def readPlayersInput do
    p1 = IO.gets(:stdio, @player1<>": ")
    p2 = IO.gets(:stdio, @player2<>": ")
    p1Input = String.split(p1) |> Enum.map(&(to_charlist(&1)))
    p2Input = String.split(p2) |> Enum.map(&(to_charlist(&1)))

    outP1 = Poker.Rules.getRank(p1Input)
    outP2 = Poker.Rules.getRank(p2Input)

    cond do
      elem(outP1, 0) != :ok ->
        IO.puts "Invalid input from #{@player1}"
      elem(outP2, 0) != :ok ->
        IO.puts "Invalid input from #{@player2}"
      true ->
        process(elem(outP1,1), elem(outP2,1))
    end

    readPlayersInput
  end

  def process({rankP1, suiteMapP1, kindMapP1} = p1, {rankP2, suiteMapP2, kindMapP2} = p2) do
    cond do
      rankP1 == rankP2 ->
        IO.puts "Both are same rank"
        processSameRank(p1, p2)
      true ->
        if Poker.Rules.compareRanks(rankP1, rankP2) > 0 do
          IO.puts "#{@player1} is winner - #{rankP1}"
        else
          IO.puts "#{@player2} is winner - #{rankP2}"
        end
    end
  end

  def processSameRank({rank, _, _} = p1, p2) do
    publishWinner(rank, processSameRankRules(p1, p2))
  end

  def processSameRankRules({rank, _, _} = p1, p2) do
    import Poker.Rules
    case rank do
      :straightflush ->
        compareStraightFlushes(p1,p2)
      :fourofkind ->
        compareNOfKinds(4,p1, p2)
      :threeofkind ->
        compareNOfKinds(3,p1, p2)
      :fullhouse ->
        compareFullHouses(p1, p2)
      :twopair ->
        compareTwoPairs(p1, p2)
      :pair ->
        compareNOfKinds(2,p1, p2)
      :flush ->
        compareHighcards(p1, p2)
      :straight ->
        compareStraightFlushes(p1,p2)
      :highcard ->
        compareHighcards(p1, p2)
    end
  end

  def publishWinner(rank, result) do
    case result do
      :tie ->
        IO.puts "#{result}"
      {:winner, 1, k1} ->
        IO.puts "#{@player1} is winner - #{rank}: #{k1}"
      {:winner, 2, k2} ->
        IO.puts "#{@player2} is winner - #{rank}: #{k2}"
    end
  end
end
