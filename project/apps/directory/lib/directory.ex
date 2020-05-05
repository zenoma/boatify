defmodule Directory do
  
  def cliente_boater(login) do
    Process.register(spawn(fn -> boater_menu(login) end), :boatclient)
    enviar_boat(0)
  end

  def cliente_stowaway(login) do
    Process.register(spawn(fn -> stowaway_menu(login) end), :stowclient)
    enviar_stow(0)
  end
 
  def enviar_stow(term), do: send(:stowclient, term)

  defp stowaway_menu(login) do   #TODO: Selección aleatoria para la repartición de carga entre servidores (del mismo tipo) duplicados.
    receive do
        0 ->
            IO.puts "\nPulsa: \n 1 -Viajes disponibles \n 2 -Mis viajes \n 3 -Salir"
            stowaway_menu(login)            
        1 ->  
            IO.puts "Buscando viajes..."
            Boater.ver_viajes() 
            |> Enum.map(fn x -> IO.inspect(x) end)
            enviar_stow(0)
            stowaway_menu(login)
        2 ->
            IO.puts "Cargando viajes..."
            Stowaway.ver_historial(login) # FILTRAR POR NOMBRE DE USUARIO
            |> Enum.map(fn x -> IO.inspect(x) end)
            enviar_stow(0)   
            stowaway_menu(login)          
        3 ->
            IO.puts "Hasta pronto!"
            Process.unregister(:stowclient)
            :ok
        _msg ->
            IO.puts "Escoge una de las opciones posibles"
            enviar_stow(0)
            stowaway_menu(login)
    end 
  end

  def enviar_boat(term), do: send(:boatclient, term)

  defp boater_menu(login) do
    receive do
      0 ->
          IO.puts "\nPulsa: \n 1 -Crear Viaje \n 2 -Mis viajes \n 3 -Salir"
          boater_menu(login)            
      1 ->  
          IO.puts "Creando viajes..."
          IO.puts Boater.crear_viajes() # Crear un viaje "bien" (Input)
          enviar_boat(0)
          boater_menu(login)
      2 ->
          IO.puts "Cargando viajes..." # Similar a Stowaway verHistorial pero filtro en BOATER
          IO.puts Boater.ver_viajes()
          enviar_boat(0)   
          boater_menu(login)          
      3 ->
          IO.puts "Hasta pronto!"
          Process.unregister(:boatclient)
          :ok
      _msg ->
          IO.puts "Escoge una de las opciones posibles"
          enviar_boat(0)
          boater_menu(login)
    end 
  end


end
