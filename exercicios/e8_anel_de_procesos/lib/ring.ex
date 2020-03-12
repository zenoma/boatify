defmodule Ring do
	def start(n, m, msg) do
		origin = self()
		list_pids = crear_n_procesos(n, [], origin)
		send List.first(list_pids), {:start_sending, self(), m, list_pids, msg}
		:ok
	end

	def crear_n_procesos(0, lista_procesos, origin) do
		lista_procesos = lista_procesos
		lista_procesos
	end

	def crear_n_procesos(n, lista_procesos, origin) do
			pid = spawn fn -> send origin, {:ok}
															recibir() end
			lista_procesos = lista_procesos++[pid]
			crear_n_procesos(n-1,lista_procesos,origin)

	end


	def recibir() do

		receive do
			{:start_sending, origin, count, pids_list, term} -> enviar_term(self(), pids_list, List.first(pids_list), term, count)
			{{:hello, origin, count, pids_list}, term} -> enviar_term(self(), pids_list, List.first(pids_list), term, count)
			{:bye, origin, count, pids_list} -> enviar_term(self(), pids_list, List.first(pids_list), "none", count)
		end
	end

	def enviar_term(self, pids_list, first_e, term, count) do
		if (count > 0) do
			send next_element(self, pids_list, List.first(pids_list)), {{:hello, self(), count-1, pids_list}, term}
			IO.puts"Mensaje enviado de #{inspect self} a #{inspect next_element(self, pids_list, List.first(pids_list))}"
			recibir()
		else
			IO.puts"Adios! Proceso: #{inspect self()}"
			send next_element(self, pids_list, List.first(pids_list)), {:bye, self(), count, pids_list}
		end
	end

	def next_element(element, [head|tail], first_e) do
		if (element == head) do
				if (tail == []) do
					first_e
				else
					hd(tail)
				end
		else
			next_element(element, tail, first_e)
		end
	end
end


