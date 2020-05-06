defmodule Directory do
  # IMPORTANTE, LOS LOGINS POR TERMINAL ENTRE COMILLAS

  def cliente_boater(login) do
    Process.register(spawn(fn -> boater_menu(login) end), :boatclient)
    enviar_boat(0)
  end

  def cliente_stowaway(login) do
    Process.register(spawn(fn -> stowaway_menu(login) end), :stowclient)
    enviar_stow(0,:ok)
  end

  def enviar_stow(term,_), do: send(:stowclient, {term, :ok})

  # TODO: Selección aleatoria para la repartición de carga entre servidores (del mismo tipo) duplicados.
  defp stowaway_menu(login) do
    receive do
      {0,_} ->
        IO.puts("\nPulsa: \n 1 -Viajes disponibles \n 2 -Historial de viajes \n 3 -Cancelar viaje \n 4 -Salir")
        stowaway_menu(login)

      {1,_} ->
        IO.puts("Buscando viajes...")

        Boater.ver_viajesDisp()
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_stow(0,:ok)
        stowaway_menu(login)

      {2,_} ->
        IO.puts("Cargando viajes...")

        Stowaway.ver_historial(login)
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_stow(0,:ok)
        stowaway_menu(login)

      {3,id} ->
        IO.puts("Cancelando viaje...")

        Stowaway.cancelar_viaje(id)
        enviar_stow(0,:ok)
        stowaway_menu(login)

      {4,_} ->
        IO.puts("Hasta pronto!")
        Process.unregister(:stowclient)
        :ok

      {_,_msg} ->
        IO.puts("Escoge una de las opciones posibles")
        enviar_stow(0,:ok)
        stowaway_menu(login)
    end
  end

  def enviar_boat(term), do: send(:boatclient, term)

  defp boater_menu(login) do
    receive do
      0 ->
        IO.puts("\nPulsa: \n 1 -Crear Viaje \n 2 -Mis viajes subidos \n 3 -Salir")
        boater_menu(login)

      1 ->
        IO.puts("Creando viajes...")
        # Crear un viaje "bien" (Input)
        Boater.crear_viajes()
        enviar_boat(0)
        boater_menu(login)

      2 ->
        IO.puts("Cargando viajes...")

        Boater.ver_viajesSubidos(login)
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_boat(0)
        boater_menu(login)

      3 ->
        IO.puts("Hasta pronto!")
        Process.unregister(:boatclient)
        :ok

      _msg ->
        IO.puts("Escoge una de las opciones posibles")
        enviar_boat(0)
        boater_menu(login)
    end
  end
end
