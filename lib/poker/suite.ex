defmodule Poker.Suite do
  @moduledoc """
  Provides set of functions on card suite
  """
  @valueOrder ['2','3','4','5','6','7','8','9','T','J','Q','K','A']
  @clubs 'C'
  @diamonds 'D'
  @hearts 'H'
  @spades 'S'
  @allSuites [@clubs, @diamonds, @hearts, @spades]

  @doc """
  Sorts the card values in the order they are defined in the @valueOrder
  """
  def sortKinds(kindList) do
    Enum.sort(kindList, &(compareKinds(&1,&2)>0))
  end

  @doc """
  Compare the card values
  Returns positive value if first > second as per values defined in the @valueOrder, nil otherwise
  """
  def compareKinds([fh|_] = _first, [sh|_] = _second) when [fh] in @valueOrder or [sh] in @valueOrder do
      indexCompare(fh,sh)
  end

  def compareKinds(_,_)  do
    nil
  end

  @doc """
  Compare card values with suite information
  Returns positive value if first > second as per values defined in the @valueOrder, nil otherwise
  """
  def compare([fh|fs] = _first, [sh|ss] = _second) when ([fh] in @valueOrder or [sh] in @valueOrder) and (fs in @allSuites or ss in @allSuites) do
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

  @doc """
  Checks if the card value and suite information are valid as defined in @allSuites and @valueOrder
  Returns boolean
  """
  def isValidCard([h|s] = _card) when s in @allSuites and [h] in @valueOrder do
    true
  end

  def isValidCard(_) do
    false
  end
end
