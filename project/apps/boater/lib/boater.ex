defmodule Boater do
  @moduledoc """
  Documentation for `Boater`.
  """
  def start() do
    levantar_servidor
    levantar_cliente()
  end


  def levantar_cliente() do 
  Process.register(spawn(fn -> menu() end), :boatclient)
  enviar(0)
  end

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
  

  def enviar(term), do: send(:boatclient, term)

  defp menu() do
    receive do
      0 ->
          IO.puts "\nPulsa: \n 1 -Crear Viaje \n 2 -Mis viajes \n 3 -Salir"
          menu()            
      1 ->  
          IO.puts "Creando viajes..."
          IO.puts crear_viajes()
          enviar(0)
          menu()
      2 ->
          IO.puts "Cargando viajes..."
          IO.puts ver_viajes()
          enviar(0)   
          menu()          
      3 ->
          IO.puts "Hasta pronto!"
          Process.unregister(:stowclient)
          :ok
      _msg ->
          IO.puts "Escoge una de las opciones posibles"
          enviar(0)
          menu()
    end 
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
        {:reply, "Estos son los viajes que hemos encontrado", []}
  end 
end