defmodule Measure do
	import Manipulating
	import Sorting

	def run(lista_de_funcions, numero_de_elementos) do

		## CREACION DE DATOS
		## Creacion de los length(lista_de_funcions) Tasks que crearan las listas de numero_de_elementos elementos

		n = length(lista_de_funcions)
		time_1 = :erlang.timestamp()

		tasks =
		  for {m, f} <- lista_de_funcions do
		    Task.async(fn ->
		    	if (f == :flatten) do
		    		lista_anidada(numero_de_elementos)
		    	else
		    		1..numero_de_elementos |> Enum.map(fn _ -> :rand.uniform(1000) end)
		    	end
		    end)
		  end

		tasks_with_results = Task.yield_many(tasks, 30000)

		results = Enum.map(tasks_with_results, fn {task, {msg, res}} ->
			res || Task.shutdown(task, :brutal_kill)
		end)

		time_2 = :erlang.timestamp()
		total_data_time = :timer.now_diff(time_2, time_1)/1000000

		IO.puts " ---------------------------------------"
		IO.puts "| Creacion de datos     : #{total_data_time}       sec |"

		## EJECUCION DE FUNCIONES
		## Creacion de los Tasks ejecutaran las funciones sobre las listas creadas

		tupla_fusionada = tupla_3(lista_de_funcions, results)

		tasks2 =
				for {m, f, l}  <- tupla_fusionada do
 					Task.async(fn ->
		    			if ((f == :reverse) == true) do
							time_3 = :erlang.timestamp()
							result = Manipulating.reverse(l)
							time_4 = :erlang.timestamp()
							total_time = :timer.now_diff(time_4, time_3)/1000000
							if total_time <= 9.9 do
								IO.puts "| Manipulating:reverse  : #{inspect total_time}       sec |"
							else
								IO.puts "| Manipulating:reverse  : interrompida                    |"
							end
							result
						else
							if ((f == :flatten) == true) do
								time_3 = :erlang.timestamp()
								result = Manipulating.flatten(l)
								time_4 = :erlang.timestamp()
								total_time = :timer.now_diff(time_4, time_3)/1000000
								if total_time <= 9.9 do
									IO.puts "| Manipulating:flatten  : #{inspect total_time}       sec |"
								else
									IO.puts "| Manipulating:flatten  : interrompida                    |"
								end
								result
							else
								if ((f == :quicksort) == true) do
									time_3 = :erlang.timestamp()
									result = Sorting.quicksort(l)
									time_4 = :erlang.timestamp()
									total_time = :timer.now_diff(time_4, time_3)/1000000
									if total_time <= 9.9 do
										IO.puts "| Sorting:quicksort  : #{inspect total_time}       sec |"
									else
										IO.puts "| Sorting:quicksort  : interrompida                    |"
									end
									result
								else
									if ((f == :mergesort) == true) do
										time_3 = :erlang.timestamp()
										result = Sorting.mergesort(l)
										time_4 = :erlang.timestamp()
										total_time = :timer.now_diff(time_4, time_3)/1000000
										if total_time <= 9.9 do
											IO.puts "| Sorting:mergesort  : #{inspect total_time}       sec |"
										else
											IO.puts "| Sorting:mergesort  : interrompida                    |"
										end
										result
									end
								end
							end
						end
		    		end)
				 end


		tasks_with_results2 = Task.yield_many(tasks2, 10000)

		results2 = Enum.map(tasks_with_results2, fn {task, {msg, res}} ->
			res || Task.shutdown(task, :brutal_kill)
		end)
		IO.puts " ---------------------------------------"
	end


	## Funcion auxiliar para crear una lista anidada de una longitud dada

	def anidar_rec(lista, lista_anidada, 1) do
		hd(lista)
	end

	def anidar_rec(lista, lista_anidada, count) do
		lista_anidada = lista_anidada++[hd(lista)]++[anidar_rec(tl(lista), lista_anidada, count-1)]
	end

	def lista_anidada(n) do
		lista = 1..n |> Enum.map(fn _ -> :rand.uniform(1000) end)
		anidar_rec(lista, [], n)
	end



	## Funcion auxiliar que fusiona una lista de 2-tuplas con una lista de listas del mismo tamano elemento a elemnto


	def tupla_3(t, l) do
    	aux_tupla_3(t, l, length(l), [])
    end

 	def aux_tupla_3(t, l, 0, final_list) do
		#IO.puts "adios aux_tupla, count vale -> #{count}"
		final_list

	end

    def aux_tupla_3(t, l, count, final_list) do
    	#IO.puts "aux_tupla, count vale -> #{count}, y el tamano de la lista -> #{length(l)}"
		final_list = final_list++[Tuple.insert_at(hd(t), 2, hd(l))]
		aux_tupla_3(tl(t), tl(l), count - 1, final_list)
	end
end
