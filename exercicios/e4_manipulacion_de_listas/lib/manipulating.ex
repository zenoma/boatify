defmodule Manipulating do
	def filter([], n) do 
		[]
	end

	def filter([h|t], n) do
		filter_rec([h|t], [], n)
	end

	def filter_rec([], filtered_list, n) do
		reverse(filtered_list)
	end

	def filter_rec([h|t], filtered_list, n) do
		if (h <= n) do
			filter_rec(t, [h|filtered_list], n)
		else
			filter_rec(t, filtered_list, n)
		end
	end
	
	def reverse([]) do
		[]
	end

	def reverse([h|t]) do
		reverse_rec([h|t], [])
	end

	def reverse_rec([], reverse_list) do
		reverse_list
	end

	def reverse_rec([h|t], reverse_list) do
		reverse_rec(t, [h|reverse_list])
	end

	def concatenate([]) do
		[]	
	end
	def concatenate([h|t]) do
		h ++ concatenate(t)
	end

	def flatten(list) do
		flatten(list, []) |> reverse()
	end

	def flatten([], flatten_list) do
		flatten_list
	end

	def flatten([[]|t], flatten_list) do
		flatten(t, flatten_list)
	end

	def flatten([h|t], flatten_list) when is_list(h) do
		flatten(t, flatten(h, flatten_list))
	end

	def flatten([h|t], flatten_list) do
		flatten(t, [h|flatten_list])
	end
end