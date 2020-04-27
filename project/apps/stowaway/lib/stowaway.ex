defmodule Stowaway do
  @moduledoc """
  Servizo de usuarios 'Stowaway' para logearse, ver viajes disponibles
  para reservar una plaza en uno de ellos, para ver su historial de viajes,
  y si quiere cancelar alguno.
  """

    #CLIENTE

    def up() do
        Process.register( spawn( fn -> menu() end), :stowclient)
        print(0)
    end
    
    def send(term), do: send(:stowclient,term)  

    defp menu() do
        receive do
            0 ->
                IO.puts "\nPulsa: \n 1 -Viajes disponibles \n 2 -Mis viajes \n 3 -Salir"
                menu()            
            1 ->  
                IO.puts "Buscando viajes..."
                #do (Esto sería una llamada a gen Server)
                print(0)
                menu()
            2 ->
                IO.puts "Cargando viajes..."
                #do (Esto sería una llamada a gen Server)
                print(0)
                menu()                
            3 ->
                IO.puts "Hasta pronto!"
                Process.unregister(:stowclient)
                :ok
            _msg ->
                IO.puts "Escoge una de las opciones posibles"
                send(:stowclient,0)
                menu()
        end 
    end

end
