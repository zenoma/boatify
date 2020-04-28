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
                #ver_viajes()
                enviar(0)
                menu()
            2 ->
                IO.puts "Cargando viajes..."
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

    # Call y Callback de las dos opciones del menú existente.
    # ATENCIÓN, SE HAN PUESTO COMO LLAMADAS ASINCRONAS (CAST) PARA QUE 
    #   FUNCIONE, PERO PROBABLEMENTE HAYA DE SER SINCRONA. ADEMÁS, 
    #   EL IO.PUTS SOLO PRINTEA SI SE LAS LLAMA DIRECTAMENTE, EL MENSAJE
    #   SE PIERDE EN EL MENÚ. HAY QUE RECUPERARLO.

    def ver_viajes(), do: GenServer.cast(:stowserver, :viajes)

    @impl true
    def handle_cast(:viajes,state) do
            IO.puts "Estos son los viajes que hemos encontrado:\n"
            {:noreply, state}
    end



    def ver_historial(), do: GenServer.cast(:stowserver, :historial)

    @impl true
    def handle_cast(:historial,state) do
            IO.puts "Tus viajes:\n"
            {:noreply, state}
    end


end
