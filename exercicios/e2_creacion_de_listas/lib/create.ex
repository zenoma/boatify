defmodule Create do 	
	def create(n) do
		create_rec(n, [])
	end

	def create_rec(0, list) do
		list
	end

	def create_rec(n, list) do
		create_rec(n-1, [n|list])
	end

	def reverse_create(x) do
		reverse_create_rec(x, [], 1)
	end

	def reverse_create_rec(0, list, _) do
		list
	end

	def reverse_create_rec(x, list, n) do
		reverse_create_rec(x-1, [n|list], n+1)
	end
end
