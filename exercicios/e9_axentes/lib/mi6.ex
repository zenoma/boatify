defmodule Mi6 do
	use GenServer
	use Agent
	import Db
	import Create
	import Manipulating

	## Client API

	def fundar() do
    if (Process.whereis(:mi6) == nil) do
  		IO.puts "Soy el Cliente/Shell: #{inspect self()}"
  		GenServer.start_link(__MODULE__, :ok, name: :mi6)
      Process.sleep(200)
    else
      Process.sleep(200)
      fundar()
    end
	end

	def recrutar(axente, destino) do
		GenServer.cast(:mi6, {:recrutar, axente, destino})
  end

	def asignar_mision(axente, :espiar) do
		GenServer.cast(:mi6, {:espiar, axente, 1})
	end

	def asignar_mision(axente, :contrainformar) do
		GenServer.cast(:mi6, {:contrainformar, axente, 1})
	end

	def consultar_estado(axente) do
		lista = GenServer.call(:mi6, {:consultar, axente})
    lista
	end

	def disolver() do
		GenServer.cast(:mi6, {:disolver, 1, 1})
	end

  ## Aux. Functions

  def despedir_agente([]) do
    IO.puts "Todos despedidos"
    {:despidos_realizados}
  end

  def despedir_agente(list) do
    IO.puts "Deteniendo a #{inspect hd(list)}"
    Agent.stop(String.to_atom(hd(list)))
    despedir_agente(tl(list))
  end

	## Server Callbacks

	def init(:ok) do	
    if (Process.whereis(String.to_atom(inspect self())) == nil) do
  		IO.puts "Soy el GenServer, puedes llamarme: #{inspect self()} o :mi6"
  		pidDB = Db.new
  		IO.puts "Soy el proceso encargado de la BD: #{inspect pidDB} o :pidDB"
      Process.sleep(200)
  	  Process.register(pidDB, String.to_atom(inspect self()))
      Process.sleep(200)
  		{:ok, "started"}
    else 
      IO.puts "** ESPERANDO A QUE :PIDDB ESTE LIBRE..."
      Process.sleep(200)
      init(:ok)
    end
	end

  def handle_cast(request, names) do
    {r, a, b} = request
    pid_DB = Process.whereis(String.to_atom(inspect self()))

    if (r == :disolver) do
      store_keys = Map.keys(Db.devolver_store(String.to_atom(inspect self())))
      IO.puts "Despidiento Agentes... Adios!"
      despedir_agente(store_keys)
      Process.sleep(100)
      IO.puts "Destroy BD con pid: #{String.to_atom(inspect self())}"
      Db.destroy(pid_DB)
      Process.sleep(200)
      {:stop, :normal, :stopped}
    else 
      if (r == :recrutar) do
        if (Db.read(pid_DB, Atom.to_string(a)) == {:error, :not_found}) do
          {_, agent} = Agent.start_link fn -> Enum.shuffle(Create.create(String.length(b))) end
          IO.puts "Soy el Agente #{Atom.to_string(a)}, con destino #{b}, y PID: #{inspect agent} llamame :#{a}"
          Process.register(agent, a)
          Db.write(pid_DB, Atom.to_string(a), b)
          Agent.get(agent, fn list -> list end)
          Process.sleep(100)
          {:noreply, names}
        else 
          if ((Db.read(pid_DB, Atom.to_string(a)) == {:error, :not_found}) == false) do
            IO.puts "El agente ya se encontraba en la bd, se omitira esta peticion de reclutamiento."
            {:noreply, names}
          end
        end
      else
        if (r == :espiar) do
          if ((Db.read(pid_DB, Atom.to_string(a)) != {:error, :not_found}) == true) do
            IO.puts "Agente #{Atom.to_string(a)}, listo para espiar! Lista espiada (filtered):"
            Agent.update(a, fn list -> Manipulating.filter(list, hd(list)) end)
            Agent.get(a, fn list -> list end)
            {:noreply, names}
          else 
            IO.puts "Agente #{Atom.to_string(a)}, NO registrado."
            {:noreply, names}
          end
        else
          if (r == :contrainformar) do
              if ((Db.read(pid_DB, Atom.to_string(a)) != {:error, :not_found}) == true)  do
                IO.puts "Agente #{Atom.to_string(a)}, listo para contrainformar! Lista contrainformada (reversed):"
                Agent.update(a, fn list -> Manipulating.reverse(list) end)
                Agent.get(a, fn list -> list end)
                {:noreply, names}
              else 
                IO.puts "Agente #{Atom.to_string(a)}, NO registrado."
                {:noreply, names}
              end
          end
        end
      end
    end
  end

  def handle_call({:consultar, axente}, _from, names) do
    if ((Db.read(Process.whereis(String.to_atom(inspect self())), Atom.to_string(axente)) == {:error, :not_found}) == true) do
       Process.sleep(200)
       {:reply, :you_are_here_we_are_not, names}
    else
      element = Agent.get(axente, fn list -> list end)
      Process.sleep(200)
      {:reply, element, names}
    end
  end
end
