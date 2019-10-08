defmodule Poker do
  @moduledoc """
  This is Poker module which works for two players
  """

  @player1 "Black"
  @player2 "White"

  @doc """
  Starts the Poker application
  """
  def main(_args) do
    readPlayersInput()
  end

  defp readPlayersInput do
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

    readPlayersInput()
  end

  defp process({rankP1, _, _} = p1, {rankP2, _, _} = p2) do
    cond do
      rankP1 == rankP2 ->
        # IO.puts "Both are same rank"
        processSameRank(p1, p2)
      true ->
        if Poker.Rules.compareRanks(rankP1, rankP2) > 0 do
          IO.puts "#{@player1} is winner - #{rankP1}"
        else
          IO.puts "#{@player2} is winner - #{rankP2}"
        end
    end
  end

  defp processSameRank({rank, _, _} = p1, p2) do
    publishWinner(rank, processSameRankRules(p1, p2), getWriter())
  end

  defp processSameRankRules({rank, _, _} = p1, p2) do
    import Poker.Rules
    kindMap1 = elem(p1,2)
    kindMap2 = elem(p2,2)
    case rank do
      :straightflush ->
        compareStraights(kindMap1, kindMap2)
      :fourofkind ->
        compareNOfKinds(4, kindMap1, kindMap2)
      :threeofkind ->
        compareNOfKinds(3, kindMap1, kindMap2)
      :fullhouse ->
        compareFullHouses(kindMap1, kindMap2)
      :twopair ->
        compareTwoPairs(kindMap1, kindMap2)
      :pair ->
        compareNOfKinds(2, kindMap1, kindMap2)
      :flush ->
        compareHighcards(kindMap1, kindMap2)
      :straight ->
        compareStraights(kindMap1, kindMap2)
      :highcard ->
        compareHighcards(kindMap1, kindMap2)
    end
  end

  @doc """
  Writes the winner to stdout based on rank and result
  """
  def publishWinner(rank, result, writer) do
    case result do
      :tie ->
        writer.("#{result}")
      {:winner, 1, k1} ->
        writer.("#{@player1} is winner - #{rank}: #{k1}")
      {:winner, 2, k2} ->
        writer.("#{@player2} is winner - #{rank}: #{k2}")
    end
  end

  defp getWriter do
    fn str -> IO.puts "#{str}" end
  end
end
