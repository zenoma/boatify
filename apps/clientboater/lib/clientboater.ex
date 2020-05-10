defmodule Clientboater do
  @moduledoc """
    Cliente de un usuario Boater.
  """

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

        Directory.subir_viaje([login | infoTrip])

        Directory.ver_historial_boat(login)

        enviar_boater(0)
        boater_menu(login)

      {2, _} ->
        IO.puts("Cargando viajes...")

        Directory.ver_historial_boat(login)

        enviar_boater(0)
        boater_menu(login)

      {3, id} ->
        IO.puts("Cancelando viaje...")

        Directory.cancel_viaje([login | id])

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
