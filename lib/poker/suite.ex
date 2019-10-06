defmodule Poker.Suite do
  @valueOrder ['2','3','4','5','6','7','8','9','T','J','Q','K','A']
  @clubs 'C'
  @diamonds 'D'
  @hearts 'H'
  @spades 'S'
  @allSuites [@clubs, @diamonds, @hearts, @spades]

  def sortKinds(kindList) do
    Enum.sort(kindList, &(compareKinds(&1,&2)>0))
  end

  ##################
  def compareKinds([fh|_] = first, [sh|_] = second) when [fh] in @valueOrder or [sh] in @valueOrder do
      indexCompare(fh,sh)
  end

  def compareKinds(_,_)  do
    nil
  end

  ###################
  def compare([fh|fs] = first, [sh|ss] = second) when ([fh] in @valueOrder or [sh] in @valueOrder) and (fs in @allSuites or ss in @allSuites) do
    cond do
      fs == ss ->
        indexCompare(fh,sh)
      true ->
        nil
    end
  end

  def compare(_,_)  do
    nil
  end

  defp indexCompare(fh, sh) do
    fi = Enum.find_index(@valueOrder, fn x -> x == [fh] end)
    si = Enum.find_index(@valueOrder, fn x -> x == [sh] end)
    cond do
      fi == nil ->
        nil
      si == nil ->
        nil
      true ->
        fi - si
    end
  end

  ###################
  def isValidCard([h|s] = card) when s in @allSuites and [h] in @valueOrder do
    true
  end

  def isValidCard(_) do
    false
  end
end
