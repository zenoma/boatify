defmodule Directory do
  # Simulación de un Balanceo de Carga (selección aleatoria)
  def select_boater() do
    # ¿Que pasa cuando el supervisor está caido?
    {_, workers} = Map.fetch(Supervisor.count_children(:boater_sup), :workers)
    # Va de 0 a workers - 1
    server = :rand.uniform(workers) - 1
    :"boater#{server}"
  end

  def select_stowaway() do
    # ¿Que pasa cuando el supervisor está caido?
    {_, workers} = Map.fetch(Supervisor.count_children(:stowaway_sup), :workers)
    # Va de 0 a workers - 1
    server = :rand.uniform(workers) - 1
    :"stowaway#{server}"
  end

  # IMPORTANTE, LOS LOGINS POR TERMINAL ENTRE COMILLAS

  def cliente_boater(login) do
    Process.register(spawn(fn -> boater_menu(login) end), :boatclient)
    enviar_boater(0)
  end

  def cliente_stowaway(login) do
    Process.register(spawn(fn -> stowaway_menu(login) end), :stowclient)
    enviar_stowaway({0})
  end

  def enviar_stowaway(term, opt), do: send(:stowclient, {term, opt})
  def enviar_stowaway(term), do: send(:stowclient, {term, :ok})

  defp stowaway_menu(login) do
    receive do
      {0, _} ->
        IO.puts(
          "\nPulsa: \n 1 -Viajes disponibles \n 2 -Reservar viaje \n 3 -Historial de viajes \n 3 -Cancelar viaje \n 4 -Salir"
        )

        stowaway_menu(login)

      {1, _} ->
        IO.puts("Buscando viajes...")

        Boater.ver_viajesDisp(select_boater())
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_stowaway(0)
        stowaway_menu(login)

      {2, id} ->
        IO.puts("Reservando viaje...")
        Boater.reservar_Boating(select_boater(), id)
        Stowaway.reservar_Stowing(select_stowaway(), [login | id])

        enviar_stowaway(0)
        stowaway_menu(login)

      {3, _} ->
        IO.puts("Cargando viajes...")

        Stowaway.ver_historial(select_stowaway(), login)
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_stowaway(0)
        stowaway_menu(login)

      {4, id} ->
        IO.puts("Cancelando viaje...")
        Boater.cancelarReserva(select_boater(), id)

        Stowaway.cancelar_viaje(select_stowaway(), [login | id])
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_stowaway(0)
        stowaway_menu(login)

      {5, _} ->
        IO.puts("Hasta pronto!")
        Process.unregister(:stowclient)
        :ok

      {_, _} ->
        IO.puts("Escoge una de las opciones posibles")
        enviar_stowaway(0)
        stowaway_menu(login)
    end
  end

  def enviar_boater(term, opt), do: send(:boatclient, {term, opt})
  def enviar_boater(term), do: send(:boatclient, {term, :ok})

  defp boater_menu(login) do
    receive do
      {0, _} ->
        IO.puts(
          "\nPulsa: \n 1, [Modelo, Fecha, Ruta, Tiempo, Asientos] -Crear Viaje \n 2 -Mis viajes subidos \n 3 -Cancelar viaje \n 4 -Salir"
        )

        boater_menu(login)

      {1, infoTrip} ->
        IO.puts("Creando viajes...")
        Boater.crear_viajes(select_boater(), [login | infoTrip])
        enviar_boater(0)
        boater_menu(login)

      {2, _} ->
        IO.puts("Cargando viajes...")

        Boater.ver_viajesSubidos(select_boater(), login)
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_boater(0)
        boater_menu(login)

      {3, id} ->
        IO.puts("Cancelando viaje...")

        Boater.cancelar_Subido(select_boater(), [login | id])
        |> Enum.map(fn x -> IO.inspect(x) end)

      {4, _} ->
        IO.puts("Hasta pronto!")
        Process.unregister(:boatclient)
        :ok

      {_, _} ->
        IO.puts("Escoge una de las opciones posibles")
        enviar_boater(0)
        boater_menu(login)
    end
  end
end
