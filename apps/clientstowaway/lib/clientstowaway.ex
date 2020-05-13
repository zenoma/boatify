defmodule Clientstowaway do
  @moduledoc """
    Cliente de un usuario Stowaway.
  """

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
        IO.puts("\nIntroduce Clientstowaway.enviar_stowaway(opción/es):
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

        GenServer.call(:directory, {:viajes_disponibles_stow})

        enviar_stowaway(0)
        stowaway_menu(login)

      {2, id} ->
        IO.puts("Reservando viaje...")

        GenServer.call(:directory, {:reservar_boat, id})
        GenServer.call(:directory, {:reservar_stow, [login | id]})

        IO.puts("Hecho!")

        enviar_stowaway(0)
        stowaway_menu(login)

      {3, _} ->
        IO.puts("Cargando viajes...")

        GenServer.call(:directory, {:ver_historial_stow, login})

        enviar_stowaway(0)
        stowaway_menu(login)

      {4, id} ->
        IO.puts("Cancelando viaje...")

        GenServer.call(:directory, {:cancel_reserva_boat, id})
        GenServer.call(:directory, {:cancel_reserva_stow, [login | id]})

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
end
