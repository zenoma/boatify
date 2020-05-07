defmodule Stowaway do
  use GenServer
  @moduledoc """
  Servizo de usuarios 'Stowaway' para logearse, ver viajes disponibles
  para reservar una plaza en uno de ellos, para ver su historial de viajes,
  y si quiere cancelar alguno.
  """

  #SUPERVISOR

  def start(n) do
    start_aux(n-1, [])
  end

  defp start_aux(n, children) when n == 0 do
    list = [%{
         id: "#{n}",
         start: {Stowaway, :levantar_servidor, [:"stowaway#{n}"]}
       }]
    children =  children ++ list

    Supervisor.start_link(children, strategy: :one_for_one, name: :stowaway_sup)
  end

  defp start_aux(n, children) do
    list = [%{
         id: "#{n}",
         start: {Stowaway, :levantar_servidor, [:"stowaway#{n}"]}
       }]
    children =  children ++ list
    start_aux(n-1, children)
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

  def filterSearch(login) do
    "./Record.csv"
    |> Path.expand()
    |> File.stream!()
    |> CSV.decode()
    |> Enum.map(fn x -> elem(x, 1) end)
    |> Enum.filter(&match?([_, ^login, _, _], &1))
  end

  def boatifySearch(id) do
    "./Record.csv"
    |> Path.expand()
    |> File.stream!()
    |> CSV.decode()
    |> Enum.map(fn x -> elem(x, 1) end)
    |> Enum.filter(&match?([^id, _, _, _], &1))
  end

 
  def ver_historial(server_name, login), do: GenServer.call(server_name, {:historial, login})
  
  def cancelar_viaje(server_name, id), do: GenServer.call(server_name, {:cancelar, id})

  @impl true
  def handle_call({:historial, login}, _from, []) do
    {:reply, filterSearch(login), []}
  end

  @impl true
  def handle_call({:cancelar, id}, _from, []) do
    IO.puts(id)
    {:reply, boatifySearch(id), []}
  end

end
