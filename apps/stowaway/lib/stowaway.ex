defmodule Stowaway do
  use GenServer

  @moduledoc """
  Servizo de usuarios 'Stowaway' para logearse, ver viajes disponibles
  para reservar una plaza en uno de ellos, para ver su historial de viajes,
  y si quiere cancelar alguno.
  """

  # SUPERVISOR

  def start(n) do
    start_aux(n - 1, [])
  end

  defp start_aux(n, children) when n == 0 do
    list = [
      %{
        id: "#{n}",
        start: {Stowaway, :levantar_servidor, [:"stowaway#{n}"]}
      }
    ]

    children = children ++ list

    Supervisor.start_link(children, strategy: :one_for_one, name: :stowaway_sup)
  end

  defp start_aux(n, children) do
    list = [
      %{
        id: "#{n}",
        start: {Stowaway, :levantar_servidor, [:"stowaway#{n}"]}
      }
    ]

    children = children ++ list
    start_aux(n - 1, children)
  end

  def stop() do
    Supervisor.stop(:stowaway_sup, :normal)
  end

  # SERVER
  def levantar_servidor(name) do
    GenServer.start_link(Stowaway, [], name: name)
  end

  def parar_servidor(name) do
    GenServer.stop(name, :normal)
  end

  @impl true
  def init(smth) do
    {:ok, smth}
  end

  defp recordSearch(login) do
    "./Record.csv"
    |> Path.expand()
    |> File.stream!()
    |> CSV.decode()
    |> Enum.map(fn x -> elem(x, 1) end)
    |> Enum.filter(&match?([_, ^login, _, _], &1))
  end

  defp getCSV() do
    "./Record.csv"
    |> Path.expand()
    |> File.stream!()
    |> CSV.decode()
    |> Enum.map(fn x -> elem(x, 1) end)
  end

  defp cancel(id, login) do
    recordCsv = getCSV()

    indexTrip =
      recordCsv
      |> Enum.find_index(&match?([^id, ^login, _, "Open"], &1))

    # TODO:
    # IF INDEX TRIP = NIL 
    #   EXIT

    {_, trip} =
      recordCsv
      |> Enum.fetch(indexTrip)

    canceledTrip = List.replace_at(trip, 3, "Canceled")

    returnCsv =
      recordCsv
      |> List.replace_at(indexTrip, canceledTrip)

    File.write!(
      "./Record.csv",
      CSV.encode(returnCsv, separator: ?\,, delimiter: "\n")
      |> Enum.take_every(1)
    )
  end

  defp reservaStow(id, login) do
    recordCsv =
      getCSV()
      |> Enum.concat([[id, login, "1", "Open"]])

    File.write!(
      "./Record.csv",
      CSV.encode(recordCsv, separator: ?\,, delimiter: "\n")
      |> Enum.take_every(1)
    )
  end

  @impl true
  def handle_call({:historial, login}, _from, []) do
    {:reply, recordSearch(login), []}
  end

  @impl true
  def handle_call({:cancelarReserva, [login | id]}, _from, []) do
    cancel(id, login)
    {:reply, recordSearch(login), []}
  end

  @impl true
  def handle_call({:reservaStow, [login | id]}, _from, []) do
    reservaStow(id, login)
    {:reply, recordSearch(login), []}
  end
end
