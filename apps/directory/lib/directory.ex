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

  # Redirections - Stowaway

  def viajes_disponibles_stow() do
    GenServer.call(select_boater(), :viajesDisp)
    |> Enum.map(fn x -> IO.inspect(x) end)
  end

  def reservar_boat(id) do
    GenServer.call(select_boater(), {:reservarBoat, id})
  end

  def reservar_stow(logid) do
    GenServer.call(select_stowaway(), {:reservaStow, logid})
  end

  def ver_historial_stow(login) do
    GenServer.call(select_stowaway(), {:historial, login})
    |> Enum.map(fn x -> IO.inspect(x) end)
  end

  def cancel_reserva_boat(id) do
    GenServer.call(select_boater(), {:cancelarReserva, id})
  end

  def cancel_reserva_stow(logid) do
    GenServer.call(select_stowaway(), {:cancelarReserva, logid})
    |> Enum.map(fn x -> IO.inspect(x) end)
  end

  # Redirections - Boater

  def subir_viaje(data) do
    GenServer.call(select_boater(), {:crear, data})
    |> Enum.map(fn x -> IO.inspect(x) end)
  end

  def ver_historial_boat(login) do
    GenServer.call(select_boater(), {:viajesSubidos, login})
    |> Enum.map(fn x -> IO.inspect(x) end)
  end

  def cancel_viaje(logid) do
    GenServer.call(select_boater(), {:cancelarSubido, logid})
    |> Enum.map(fn x -> IO.inspect(x) end)
  end
end
