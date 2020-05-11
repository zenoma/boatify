defmodule Boater do
  use GenServer

  @moduledoc """
    Servicio "Boater", encargado de realizar las lecturas
    y escrituras sobre la base de datos "Trip.csv" que 
    recoge la información completa de los viajes registrados
    en el sistema.
  """

  # SUPERVISOR - BoaterServices

  @doc """
    Inicia "n" servicios (procesos) Boater y los linkea con
    el supervisor encargado de Boater.
  """
  def start(n) do
    start(n - 1, [])
  end

  def start(n, children) when n == 0 do
    list = [
      %{
        id: "#{n}",
        start: {Boater, :levantar_servidor, [:"boater#{n}"]}
      }
    ]

    children = children ++ list

    Supervisor.start_link(children, strategy: :one_for_one, name: :boater_sup)
  end

  def start(n, children) do
    list = [
      %{
        id: "#{n}",
        start: {Boater, :levantar_servidor, [:"boater#{n}"]}
      }
    ]

    children = children ++ list
    start(n - 1, children)
  end

  @doc """
    Para los servicios asignados al supervisor de Boaters.
  """
  def stop() do
    Supervisor.stop(:boater_sup, :normal)
  end

  # SERVER - Inicialización

  @doc """
    Inicia un único servicio Boater registrado con el nombre que se le envía.
  """
  def levantar_servidor(name) do
    GenServer.start_link(Boater, [], name: name)
  end

  @doc """
    Para el servicio Boater respectivo al nombre que se le envía.
  """
  def parar_servidor(name) do
    GenServer.stop(name, :normal)
  end

  @impl true
  def init(smth) do
    {:ok, smth}
  end

  # SERVER - CallBacks

  @impl true
  def handle_call({:crear, l}, _from, []) do
    crearTrip(l)
    {:reply, ["Se ha añadido correctamente el viaje"], []}
  end

  @impl true
  def handle_call({:viajesSubidos, login}, _from, []) do
    {:reply, filterSearch(login), []}
  end

  @impl true
  def handle_call(:viajesDisp, _from, []) do
    {:reply, filterSearch(), []}
  end

  @impl true
  def handle_call({:cancelarSubido, [login | id]}, _from, []) do
    cancel(id, login)
    {:reply, filterSearch(login), []}
  end

  @impl true
  def handle_call({:cancelarReserva, id}, _from, []) do
    cancelReserva(id)
    {:reply, :ok, []}
  end

  @impl true
  def handle_call({:reservarBoat, id}, _from, []) do
    reservarBoat(id)
    {:reply, :ok, []}
  end

  # SERVER - AuxMethods

  defp crearTrip([boater, model, date, route, time, seats]) do
    id =
      getCSV()
      |> Enum.at(-1)
      |> Enum.at(0)
      |> Integer.parse()
      |> elem(0)
      |> Kernel.+(1)
      |> Integer.to_string()

    recordCsv =
      getCSV()
      |> Enum.concat([
        [
          id,
          boater,
          model,
          date,
          route,
          time,
          seats,
          seats,
          "Open"
        ]
      ])

    File.write!(
      "./Trip.csv",
      CSV.encode(recordCsv, separator: ?\,, delimiter: "\n")
      |> Enum.take_every(1)
    )
  end

  defp filterSearch() do
    "./Trip.csv"
    |> Path.expand()
    |> File.stream!()
    |> CSV.decode()
    |> Enum.map(fn x -> elem(x, 1) end)
    |> Enum.filter(&match?([_, _, _, _, _, _, _, _, "Open"], &1))
  end

  defp filterSearch(login) do
    "./Trip.csv"
    |> Path.expand()
    |> File.stream!()
    |> CSV.decode()
    |> Enum.map(fn x -> elem(x, 1) end)
    |> Enum.filter(&match?([_, ^login, _, _, _, _, _, _, _], &1))
  end

  defp getCSV() do
    "./Trip.csv"
    |> Path.expand()
    |> File.stream!()
    |> CSV.decode()
    |> Enum.map(fn x -> elem(x, 1) end)
  end

  defp cancel(id, login) do
    recordCsv = getCSV()

    indexTrip =
      recordCsv
      |> Enum.find_index(&match?([^id, ^login, _, _, _, _, _, _, "Open"], &1))

    {_, trip} =
      recordCsv
      |> Enum.fetch(indexTrip)

    canceledTrip = List.replace_at(trip, 8, "Canceled")

    returnCsv =
      recordCsv
      |> List.replace_at(indexTrip, canceledTrip)

    File.write!(
      "./Trip.csv",
      CSV.encode(returnCsv, separator: ?\,, delimiter: "\n")
      |> Enum.take_every(1)
    )
  end

  defp cancelReserva(id) do
    recordCsv = getCSV()

    indexTrip =
      recordCsv
      |> Enum.find_index(&match?([^id, _, _, _, _, _, _, _, "Open"], &1))

    {_, trip} =
      recordCsv
      |> Enum.fetch(indexTrip)

    nuevosDisponibles =
      getCSV()
      |> Enum.at(indexTrip)
      |> Enum.at(7)
      |> Integer.parse()
      |> elem(0)
      |> Kernel.+(1)
      |> Integer.to_string()

    canceledTrip = List.replace_at(trip, 7, nuevosDisponibles)

    returnCsv =
      recordCsv
      |> List.replace_at(indexTrip, canceledTrip)

    File.write!(
      "./Trip.csv",
      CSV.encode(returnCsv, separator: ?\,, delimiter: "\n")
      |> Enum.take_every(1)
    )
  end

  defp reservarBoat(id) do
    recordCsv = getCSV()

    indexTrip =
      recordCsv
      |> Enum.find_index(&match?([^id, _, _, _, _, _, _, _, "Open"], &1))

    {_, trip} =
      recordCsv
      |> Enum.fetch(indexTrip)

    nuevosDisponibles =
      getCSV()
      |> Enum.at(indexTrip)
      |> Enum.at(7)
      |> Integer.parse()
      |> elem(0)
      |> Kernel.-(1)
      |> Integer.to_string()

    canceledTrip = List.replace_at(trip, 7, nuevosDisponibles)

    returnCsv =
      recordCsv
      |> List.replace_at(indexTrip, canceledTrip)

    File.write!(
      "./Trip.csv",
      CSV.encode(returnCsv, separator: ?\,, delimiter: "\n")
      |> Enum.take_every(1)
    )
  end
end
