defmodule Stowaway do
  @moduledoc """
  Servizo de usuarios 'Stowaway' para logearse, ver viajes disponibles
  para reservar una plaza en uno de ellos, para ver su historial de viajes,
  y si quiere cancelar alguno.
  """

    #CLIENTE

    def levantar_cliente() do
        Process.register( spawn( fn -> menu() end), :stowclient)
        enviar(0)
    end
    
    def enviar(term), do: send(:stowclient,term)  

    defp menu() do
        receive do
            0 ->
                IO.puts "\nPulsa: \n 1 -Viajes disponibles \n 2 -Mis viajes \n 3 -Salir"
                menu()            
            1 ->  
                IO.puts "Buscando viajes..."
                IO.puts ver_viajes()
                enviar(0)
                menu()
            2 ->
                IO.puts "Cargando viajes..."
                IO.puts ver_historial()
                enviar(0)   
                menu()          
            3 ->
                IO.puts "Hasta pronto!"
                Process.unregister(:stowclient)
                :ok
            _msg ->
                IO.puts "Escoge una de las opciones posibles"
                enviar(0)
                menu()
        end 
    end


    #SERVER
 
    def levantar_servidor() do
        GenServer.start_link(Stowaway, [], name: :stowserver)
    end

    @impl true
    def init(smth) do 
        {:ok, smth} 
    end


    def ver_viajes(), do: GenServer.call(:stowserver, :viajes)

    @impl true
    def handle_call(:viajes, _from, []) do
            {:reply, "Estos son los viajes que hemos encontrado", []}
    end


    def ver_historial(), do: GenServer.call(:stowserver, :historial)
    
    @impl true
    def handle_call(:historial, _from, []) do
            {:reply, "Tus viajes:" ,[]}
    end


end
