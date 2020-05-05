defmodule Directory do
  
  def levantar_cliente(type) do
    case type do
      :boater -> 
        Process.register(spawn(fn -> boater_menu() end), :boatclient)
        enviar_boat(0)
      :stowaway -> 
        Process.register(spawn(fn -> stowaway_menu() end), :stowclient)
        enviar_stow(0)
      _ -> IO.puts "No se encuentra dicho cliente"
    end
  end

 
  def enviar_stow(term), do: send(:stowclient, term)

  defp stowaway_menu() do
    receive do
        0 ->
            IO.puts "\nPulsa: \n 1 -Viajes disponibles \n 2 -Mis viajes \n 3 -Salir"
            stowaway_menu()            
        1 ->  
            IO.puts "Buscando viajes..."
            IO.puts Boater.ver_viajes()
            enviar_stow(0)
            stowaway_menu()
        2 ->
            IO.puts "Cargando viajes..."
            IO.puts Stowaway.ver_historial()
            enviar_stow(0)   
            stowaway_menu()          
        3 ->
            IO.puts "Hasta pronto!"
            Process.unregister(:stowclient)
            :ok
        _msg ->
            IO.puts "Escoge una de las opciones posibles"
            enviar_stow(0)
            stowaway_menu()
    end 
  end

  def enviar_boat(term), do: send(:boatclient, term)

  defp boater_menu() do
    receive do
      0 ->
          IO.puts "\nPulsa: \n 1 -Crear Viaje \n 2 -Mis viajes \n 3 -Salir"
          boater_menu()            
      1 ->  
          IO.puts "Creando viajes..."
          IO.puts Boater.crear_viajes()
          enviar_boat(0)
          boater_menu()
      2 ->
          IO.puts "Cargando viajes..."
          IO.puts Boater.ver_viajes()
          enviar_boat(0)   
          boater_menu()          
      3 ->
          IO.puts "Hasta pronto!"
          Process.unregister(:boatclient)
          :ok
      _msg ->
          IO.puts "Escoge una de las opciones posibles"
          enviar_boat(0)
          boater_menu()
    end 
  end


end
