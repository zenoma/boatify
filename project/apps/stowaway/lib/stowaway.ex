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


    def ver_historial(), do: GenServer.call(:stowserver, :historial)
    
    @impl true
    def handle_call(:historial, _from, []) do
            {:reply, "Tus viajes:" ,[]}
    end


end
