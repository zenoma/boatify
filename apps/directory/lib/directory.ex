defmodule Directory do
  @moduledoc """
    Servicio Directory que realiza el papel de intermediario
    entre el acceso de clientes y los distintos servicios. 
  """

  # SERVER - Inicialización
  @doc """
    Inicia el servicio (procesos) Directory y vigilado por 
    un supervisor encargado.
  """
  def start() do
    list = [
      %{
        id: :Directory,
        start: {Directory, :levantar_servidor, []}
      }
    ]

    Supervisor.start_link(list, strategy: :one_for_one, name: :directory_sup)
  end

  @doc """
    Para los servicios asignados al supervisor del Directory.
  """
  def stop() do
    Supervisor.stop(:directory_sup, :normal)
  end

  @doc """
    Inicia un único servicio Directory registrado con el nombre que se le envía.
  """

  def levantar_servidor() do
    GenServer.start_link(Directory, [], name: :directory)
  end

  @doc """
    Para el servicio Directory respectivo al nombre que se le envía.
  """
  def parar_servidor() do
    GenServer.stop(:directory, :normal)
  end

  defp select_boater() do
    {_, workers} = Map.fetch(Supervisor.count_children(:boater_sup), :workers)
    # Va de 0 a workers - 1
    server = :rand.uniform(workers) - 1
    :"boater#{server}"
  end

  defp select_stowaway() do
    {_, workers} = Map.fetch(Supervisor.count_children(:stowaway_sup), :workers)
    # Va de 0 a workers - 1
    server = :rand.uniform(workers) - 1
    :"stowaway#{server}"
  end

  @impl true
  def init(smth) do
    {:ok, smth}
  end

  # Redirection Callbacks - Stowaway

  @impl true
  def handle_call({:viajes_disponibles_stow}, _from, []) do
    GenServer.call(select_boater(), :viajesDisp)
    |> Enum.map(fn x -> IO.inspect(x) end)

    {:reply, :ok, []}
  end

  @impl true
  def handle_call({:reservar_boat, id}, _from, []) do
    GenServer.call(select_boater(), {:reservarBoat, id})
    {:reply, :ok, []}
  end

  @impl true
  def handle_call({:reservar_stow, logid}, _from, []) do
    GenServer.call(select_stowaway(), {:reservaStow, logid})
    {:reply, :ok, []}
  end

  @impl true
  def handle_call({:ver_historial_stow, login}, _from, []) do
    GenServer.call(select_stowaway(), {:historial, login})
    |> Enum.map(fn x -> IO.inspect(x) end)

    {:reply, :ok, []}
  end

  @impl true
  def handle_call({:cancel_reserva_boat, id}, _from, []) do
    GenServer.call(select_boater(), {:cancelarReserva, id})
    {:reply, :ok, []}
  end

  @impl true
  def handle_call({:cancel_reserva_stow, logid}, _from, []) do
    GenServer.call(select_stowaway(), {:cancelarReserva, logid})
    {:reply, :ok, []}
  end

  # Redirection Callbacks - Boater

  @impl true
  def handle_call({:subir_viaje, data}, _from, []) do
    GenServer.call(select_boater(), {:crear, data})
    |> Enum.map(fn x -> IO.inspect(x) end)

    {:reply, :ok, []}
  end

  @impl true
  def handle_call({:ver_historial_boat, login}, _from, []) do
    GenServer.call(select_boater(), {:viajesSubidos, login})
    |> Enum.map(fn x -> IO.inspect(x) end)

    {:reply, :ok, []}
  end

  @impl true
  def handle_call({:cancel_viaje, logid}, _from, []) do
    GenServer.call(select_boater(), {:cancelarSubido, logid})
    |> Enum.map(fn x -> IO.inspect(x) end)

    {:reply, :ok, []}
  end
end
