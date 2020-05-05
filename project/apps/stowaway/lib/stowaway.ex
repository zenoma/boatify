defmodule Stowaway do
  @moduledoc """
  Servizo de usuarios 'Stowaway' para logearse, ver viajes disponibles
  para reservar una plaza en uno de ellos, para ver su historial de viajes,
  y si quiere cancelar alguno.
  """
  
    #SERVER
 
    def levantar_servidor() do
        GenServer.start_link(Stowaway, [], name: :stowserver)
    end

    @impl true
    def init(smth) do 
        {:ok, smth} 
    end


    def ver_viajes(), do: GenServer.call(:stowserver, :viajes)

    @impl true
    def handle_call(:viajes, _from, []) do
            {:reply, "Estos son los viajes que hemos encontrado", []}
    end


    @doc """
        Consulta el historial de viajes del stowaway logueado
    """
    def ver_historial(login) do
        GenServer.call(:stowserver, {:historial, login})
    end
    
    @impl true
    def handle_call({:historial,login}, _from, []) do
        {:reply, filterSearch("#{login}") ,[]}
    end

    def filterSearch(login) do "../Record.csv" 
        |> Path.expand 
        |> File.stream! 
        |> CSV.decode 
        |> Enum.map(fn x -> elem(x,1) end) 
        |> Enum.filter(&match?([_,login,_,_],&1))
    end

end
