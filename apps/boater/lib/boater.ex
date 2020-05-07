defmodule Boater do
  use GenServer
  @moduledoc """
  Servizo de usuarios 'Boater' para logearse, para crear viajes
  , para ver su historial de viajes,
  y si quiere cancelar alguno.
  """

  #SUPERVISOR
  def start(name) do
    # FIXME: Hacer bucle para la creación
    children = [
      %{
        id: name,
        start: {Boater, :levantar_servidor, [name]}
      }]

      Supervisor.start_link(children, strategy: :one_for_one, name: :boater_sup)
  end

  def stop() do
    Supervisor.stop(:boater_sup, :normal)
  end

  # SERVER
  def levantar_servidor(name) do
    GenServer.start_link(Boater, [], name: name)
  end

  def parar_servidor(name) do
    GenServer.stop(name, :normal)
  end

  @impl true
  def init(smth) do
    {:ok, smth}
  end

  def escribir(archivo, data) do
    File.open(archivo, [:append])
    |> elem(1)
    |> IO.binwrite(data)
  end

  def to_csv(data) do
    escribir(
      "./Trip.csv",
      CSV.encode(data, separator: ?\,, delimiter: "\n")
      |> Enum.take(1)
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
  
  def ver_viajesDisp(), do: GenServer.call(:boatserver, :viajesDisp)

  def ver_viajesSubidos(login), do: GenServer.call(:boatserver, {:viajesSubidos, login})

  def crear_viajes(infoTrip), do: GenServer.call(:boatserver, {:crear, infoTrip})

  @impl true
  # TODO Falta montar el viaje correctamente
  def handle_call({:crear, [boater, model, date, route, time, seats]}, _from, []) do
    to_csv([
      [
        "DamnItTheId",
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
    
    {:reply, "Se ha añadido correctamente el viaje", []}
  end

  @impl true
  def handle_call({:viajesSubidos, login}, _from, []) do
    {:reply, filterSearch(login), []}
  end
  
  @impl true
  def handle_call(:viajesDisp, _from, []) do
    {:reply, filterSearch(), []}
  end  
  
end