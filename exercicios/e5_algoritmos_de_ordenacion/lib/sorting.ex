defmodule Sorting do

    def quicksort([]), do: []
    def quicksort([pivot | rest]) do
      { left, right } = Enum.split_with(rest, &(&1 < pivot))
      quicksort(left) ++ [pivot | quicksort(right)]
    end

    def mergesort(input) when length(input) <= 1 do
      input
    end

    def mergesort(input) do
      splitting_point = length(input) |> div(2)
      { left, right } = Enum.split(input, splitting_point)
      :lists.merge(mergesort(left), mergesort(right))
    end
end
