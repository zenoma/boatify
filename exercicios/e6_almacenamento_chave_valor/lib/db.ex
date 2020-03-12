defmodule Db do 
	def new() do
		pid = spawn fn -> crear_bd(self()) end 
	end

	def crear_bd(ref) do
		store = %{}
		IO.puts "-- Database created."
		IO.puts "-- PID/reference:"
		IO.puts(inspect(ref))
		IO.puts"-- Database state:"
		IO.inspect store
		recibir(ref, store)
		
	end

	def recibir(ref, store) do
		IO.puts"-- Esperando mensajes..."
		IO.puts" * * * * * * * * * * * * * * * * * * *"
		receive do
				{:store, self} -> devolver_store_bd(store, ref, self)
				{:write, key, element, self} -> write_bd(ref, key, element, store, self)
				{:delete, key, self} -> delete_bd(ref, key, store, self)
				{:read, key, self} -> read_bd(ref, key, store, self)
				{:match, element, self} -> match_bd(ref, element, store, self)
				{:destroy, self} -> send self, {:ok}
		end
	end

	def mostrar_store(ref, store) do
		IO.puts"-- Database name:"
		IO.inspect ref
		IO.puts"-- Database state:"
		IO.inspect store
		recibir(ref, store)
	end

	def devolver_store(ref) do
		send ref, {:store, self()}
		receive do 
			{:ur_store, store} -> store
		end
	end

	def devolver_store_bd(store, ref, self) do
		send self, {:ur_store, store}
		recibir(ref, store)
	end

	def write(ref, key, element) do
		send ref, {:write, key, element, self()}
		receive do 
			{:wrote, ref} -> ref
		end
	end

	def write_bd(ref, key, element, store, self) do
		store = Map.put(store, key, element)
		send self, {:wrote, ref}
		mostrar_store(ref, store)
	end

	def delete(ref, key) do 
		send ref, {:delete, key, self()}
		receive do 
			{:deleted, ref} -> ref
			{:error} -> {:error, :not_found}
		end
	end
	
	def delete_bd(ref, key, store, self) do
		if Map.has_key?(store, key) do
			store = Map.delete(store, key)
			send self, {:deleted, ref}
			mostrar_store(ref, store)
		else
			IO.puts"ERROR: La clave no existe en la BD consultada"
			send self, {:error}
			mostrar_store(ref, store)
		end
	end

	def read(ref, key) do
		send ref, {:read, key, self()}	
		receive do
			{:ok, result} -> {:ok, result}
			{:error, :not_found} ->	{:error, :not_found}
		end
	end
		
	def read_bd(ref, key, store, self) do
		result = Map.get(store, key)
		if ((inspect result)!="nil") do
			send self, {:ok, result}
			mostrar_store(ref, store)
		else
			send self, {:error, :not_found}
			mostrar_store(ref, store)
		end
	end

	def destroy(ref) do
		send ref, {:destroy, self()}
		receive do
			{:ok} -> :ok
		end
	end

	def match(ref, element) do
		send ref, {:match, element, self()}
		receive do
			{:matched, final_keys} -> final_keys
		end
	end

	def match_bd(ref, element, store, self) do
		list = Map.keys(store)
		comprobar(list, element, [], store, self)
		mostrar_store(ref, store)
	end

	def comprobar([], element, final_keys, store, self) do
		IO.puts inspect final_keys
		send self, {:matched, final_keys}
	end


	def comprobar([head|tail], element, final_keys, store, self) do
		if Map.get(store, head) == element do
			final_keys = final_keys++[head]
			comprobar(tail, element, final_keys, store, self)
		else
			comprobar(tail, element, final_keys, store, self)
		end	
		
	end
end

