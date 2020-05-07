defmodule Boater do
  use GenServer
  @moduledoc """
  Servizo de usuarios 'Boater' para logearse, para crear viajes
  , para ver su historial de viajes,
  y si quiere cancelar alguno.
  """

  #SUPERVISOR
  def start(n) do
    start_aux(n-1, [])
  end

  defp start_aux(n, children) when n == 0 do
    list = [%{
         id: "#{n}",
         start: {Boater, :levantar_servidor, [:"boater#{n}"]}
       }]
    children =  children ++ list

    Supervisor.start_link(children, strategy: :one_for_one, name: :boater_sup)
  end

  defp start_aux(n, children) do
    list = [%{
         id: "#{n}",
         start: {Boater, :levantar_servidor, [:"boater#{n}"]}
       }]
    children =  children ++ list
    start_aux(n-1, children)
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
  
  def getCSV() do
    "./Trip.csv"
    |> Path.expand()
    |> File.stream!()
    |> CSV.decode()
    |> Enum.map(fn x -> elem(x, 1) end)
  end

  def cancel(id,login) do
    
    recordCsv = getCSV()

    indexTrip = recordCsv
    |> Enum.find_index(&match?([^id, ^login, _, _, _, _, _, _, "Open"], &1))

    # MayBe: If indexTrip = null return ERROR, NO TRIP

    {_,trip} = recordCsv
    |> Enum.fetch(indexTrip) 
    canceledTrip = List.replace_at(trip, 8, "Canceled")

    returnCsv = recordCsv
    |> List.replace_at(indexTrip, canceledTrip)

    File.write!("./Trip.csv", 
      CSV.encode(returnCsv, separator: ?\,, delimiter: "\n")
      |> Enum.take_every(1)
      )
  end  

  def crear_viajes(server_name, infoTrip), do: GenServer.call(server_name, {:crear, infoTrip})  

  def ver_viajesDisp(server_name), do: GenServer.call(server_name, :viajesDisp)

  def ver_viajesSubidos(server_name, login), do: GenServer.call(server_name, {:viajesSubidos, login})

  def cancelar_Subido(server_name, idViaje), do: GenServer.call(server_name, {:cancelarSubido, idViaje})  

  @impl true
  def handle_call({:crear, [boater, model, date, route, time, seats]}, _from, []) do
    # TODO Asignación del Id
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
  
  @impl true
  def handle_call({:cancelarSubido, [login|id]}, _from, []) do
    cancel(id,login)
    {:reply, filterSearch(login), []}
  end

end
