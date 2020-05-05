defmodule Boater do
  @moduledoc """
  Documentation for `Boater`.
  """

  def escribir(archivo, data) do
        File.open(archivo, [:append]) 
        |> elem(1) 
        |> IO.binwrite(data) 
  end

  def to_csv(data) do #Para escribirLista de Listas
    col_sep = ","
    fila_sep = "\n"

    csv_data =
      for fila <- data, into: "" do
        Enum.join(fila, col_sep) <> fila_sep
      end

    escribir("../Trip.csv", csv_data)
  end

  #SERVER
  def levantar_servidor() do
  GenServer.start_link(Boater, [], name: :boatserver)
  end

  @impl true
  def init(smth) do 
    {:ok, smth} 
  end

  def crear_viajes(), do: GenServer.call(:boatserver, :crear)

  @impl true
  def handle_call(:crear, _from, []) do #TODO Falta montar el viaje correctamente
        to_csv([["1","Raquel","Hanse -458","22/11/2020","Gomera – Las Palmas","06:20:00 AM","6","6","Close"]])
        {:reply, "Se ha añadido correctamente el viaje", []}
  end

  def ver_viajes(), do: GenServer.call(:boatserver, :viajes)

  @impl true
  def handle_call(:viajes, _from, []) do
        {:reply,  filterSearch(), []}
  end 

  defp filterSearch(), do: "../Trip.csv" |> Path.expand |> File.stream! |> CSV.decode |> Enum.map(fn x -> elem(x,1) end) |> Enum.filter(&match?([_,_,_,_,_,_,_,_,"Open"],&1)) 

end  


