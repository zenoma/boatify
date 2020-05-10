defmodule Directory do
  @moduledoc """
    Servicio Directory que realiza el papel de intermediario
    entre el acceso de clientes y los distintos servicios. 
  """

  defp select_boater() do
    # ¿Que pasa cuando el supervisor está caido?
    {_, workers} = Map.fetch(Supervisor.count_children(:boater_sup), :workers)
    # Va de 0 a workers - 1
    server = :rand.uniform(workers) - 1
    :"boater#{server}"
  end

  defp select_stowaway() do
    # ¿Que pasa cuando el supervisor está caido?
    {_, workers} = Map.fetch(Supervisor.count_children(:stowaway_sup), :workers)
    # Va de 0 a workers - 1
    server = :rand.uniform(workers) - 1
    :"stowaway#{server}"
  end

  # Cliente: Stowaway

  @doc """
    Inicia el proceso que representa el cliente con intencionalidad
    de Stowaway, junto a su login para identificarlo.
  """
  def cliente_stowaway(login) do
    Process.register(spawn(fn -> stowaway_menu(login) end), :stowclient)
    enviar_stowaway({0})
  end

  @doc """
    Llamada que simula el envío de un mensaje al cliente Stowaway y
    notifica al Directorio la petición concreta para que este la gestione.
    Este método en concreto acepta un parametro de selección de llamada..
  """
  def enviar_stowaway(term), do: send(:stowclient, {term, :ok})

  @doc """
    Llamada que simula el envío de un mensaje al cliente Stowaway y
    notifica al Directorio la petición concreta para que este la gestione.
    Este método en concreto acepta un parametro de selección de llamada 
    junto a otro de introducción de datos necesarios.
  """
  def enviar_stowaway(term, opt), do: send(:stowclient, {term, opt})

  defp stowaway_menu(login) do
    receive do
      {0, _} ->
        IO.puts("\nIntroduce Directory.enviar_stowaway(opción/es):
+--------------------------------------+
|   1          -Viajes disponibles     |
| (2,id)       -Reservar viaje         |
|   3          -Historial de viajes    |
| (4,id)       -Cancelar viaje         |
|   5          -Salir                  |
+--------------------------------------+")

        stowaway_menu(login)

      {1, _} ->
        IO.puts("Buscando viajes...")

        GenServer.call(select_boater(), :viajesDisp)
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_stowaway(0)
        stowaway_menu(login)

      {2, id} ->
        IO.puts("Reservando viaje...")
        GenServer.call(select_boater(), {:reservarBoat, id})
        GenServer.call(select_stowaway(), {:reservaStow, [login | id]})

        enviar_stowaway(0)
        stowaway_menu(login)

      {3, _} ->
        IO.puts("Cargando viajes...")

        GenServer.call(select_stowaway(), {:historial, login})
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_stowaway(0)
        stowaway_menu(login)

      {4, id} ->
        IO.puts("Cancelando viaje...")
        GenServer.call(select_boater(), {:cancelarReserva, id})

        GenServer.call(select_stowaway(), {:cancelarReserva, [login | id]})
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

  # Cliente: Boater

  @doc """
    Inicia el proceso que representa el cliente con intencionalidad
    de Boater, junto a su login para identificarlo.
  """
  def cliente_boater(login) do
    Process.register(spawn(fn -> boater_menu(login) end), :boatclient)
    enviar_boater(0)
  end

  @doc """
    Llamada que simula el envío de un mensaje al cliente Boater y
    notifica al Directorio la petición concreta para que este la gestione.
    Este método en concreto acepta un parametro de selección de llamada.
  """
  def enviar_boater(term), do: send(:boatclient, {term, :ok})

  @doc """
    Llamada que simula el envío de un mensaje al cliente Boater y
    notifica al Directorio la petición concreta para que este la gestione.
    Este método en concreto acepta un parametro de selección de llamada 
    junto a otro de introducción de datos necesarios.
  """
  def enviar_boater(term, opt), do: send(:boatclient, {term, opt})

  defp boater_menu(login) do
    receive do
      {0, _} ->
        IO.puts("\nIntroduce Directory.enviar_boater(opción/es):   
+-----------------------------------------------------------------+
|(1, [Modelo, Fecha, Ruta, Tiempo, Asientos]) -Crear Viaje        |
|                    2                        -Mis viajes subidos |
|                  (3,id)                     -Cancelar viaje     |
|                    4                        -Salir              |
+-----------------------------------------------------------------+")

        boater_menu(login)

      {1, infoTrip} ->
        IO.puts("Subiendo viaje...")

        GenServer.call(select_boater(), {:crear, [login | infoTrip]})
        |> Enum.map(fn x -> IO.inspect(x) end)

        GenServer.call(select_boater(), {:viajesSubidos, login})
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_boater(0)
        boater_menu(login)

      {2, _} ->
        IO.puts("Cargando viajes...")

        GenServer.call(select_boater(), {:viajesSubidos, login})
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_boater(0)
        boater_menu(login)

      {3, id} ->
        IO.puts("Cancelando viaje...")

        GenServer.call(select_boater(), {:cancelarSubido, [login | id]})
        |> Enum.map(fn x -> IO.inspect(x) end)

        enviar_boater(0)
        boater_menu(login)

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
