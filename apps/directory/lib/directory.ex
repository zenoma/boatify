defmodule Directory do
  # IMPORTANTE, LOS LOGINS POR TERMINAL ENTRE COMILLAS

  def cliente_boater(login) do
    Process.register(spawn(fn -> boater_menu(login) end), :boatclient)
    enviar_boat(0)
  end

  def cliente_stowaway(login) do
    Process.register(spawn(fn -> stowaway_menu(login) end), :stowclient)
    enviar_stow({0})
  end

  def enviar_stow(term, opt), do: send(:stowclient, {term, opt})
  def enviar_stow(term), do: send(:stowclient, {term, :ok})

  # TODO: Selección aleatoria para la repartición de carga entre servidores (del mismo tipo) duplicados.
  defp stowaway_menu(login) do
    receive do
      {0, _} ->
        IO.puts(
          "\nPulsa: \n 1 -Viajes disponibles \n 2 -Historial de viajes \n 3 -Cancelar viaje \n 4 -Salir"
        )

        stowaway_menu(login)

      {1, _} ->
        IO.puts("Buscando viajes...")

        Boater.ver_viajesDisp()
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_stow(0)
        stowaway_menu(login)

      {2, _} ->
        IO.puts("Cargando viajes...")

        Stowaway.ver_historial(login)
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_stow(0)
        stowaway_menu(login)

      {3, id} ->
        IO.puts("Cancelando viaje...")
        # SI NO ENCUENTRA ID, QUE PETE
        Stowaway.cancelar_viaje(id)
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_stow(0)
        stowaway_menu(login)

      {4, _} ->
        IO.puts("Hasta pronto!")
        Process.unregister(:stowclient)
        :ok

      {_, _} ->
        IO.puts("Escoge una de las opciones posibles")
        enviar_stow(0)
        stowaway_menu(login)
    end
  end

  def enviar_boat(term, opt), do: send(:boatclient, {term, opt})
  def enviar_boat(term), do: send(:boatclient, {term, :ok})

  defp boater_menu(login) do
    receive do
      {0, _} ->
        IO.puts(
          "\nPulsa: \n 1, [Modelo, Fecha, Ruta, Tiempo, Asientos] -Crear Viaje \n 2 -Mis viajes subidos \n 3 -Salir"
        )

        boater_menu(login)

      {1, infoTrip} ->
        IO.puts("Creando viajes...")
        Boater.crear_viajes([login | infoTrip])
        enviar_boat(0)
        boater_menu(login)

      {2, _} ->
        IO.puts("Cargando viajes...")

        Boater.ver_viajesSubidos(login)
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_boat(0)
        boater_menu(login)

      {3, _} ->
        IO.puts("Hasta pronto!")
        Process.unregister(:boatclient)
        :ok

      {_, _} ->
        IO.puts("Escoge una de las opciones posibles")
        enviar_boat(0)
        boater_menu(login)
    end
  end
end
