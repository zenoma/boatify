defmodule BoaterTest do
  use ExUnit.Case
  doctest Boater

  test "levantar_servidor" do
   {_,pid} = Boater.levantar_servidor(:ServerName)
   assert Process.alive?(pid) ==  true
  end

  test "parar_servidor" do
    {_,pid} = Boater.levantar_servidor(:ServerName)
    Boater.parar_servidor(:ServerName)
    assert Process.alive?(pid) ==  false
  end

  test "start" do
    {_,pid} = Boater.start(1)
    assert Process.alive?(pid) ==  true
  end

  test "stop" do
    {_,pid} =  Boater.start(1)
    Boater.stop
    assert Process.alive?(pid) ==  false
  end

  # test "ver_viajesDisp" do
  #   Boater.levantar_servidor(:ServerName)
  #   assertBoater.ver_viajesDisp(:ServerName) == [
  #     ["1", "Raquel", "Hanse -458", "22/11/2020", "Gomera – Las Palmas",
  #      "06:20:00 AM", "6", "6", "Open"],
  #     ["2", "Sergio", "Brava 22 W.A", "23/11/2020", "Lanzarote – FuerteVentura",
  #      "10:20:00 PM", "5", "3", "Open"],
  #     ["3", "Sandra", "Br 22 W.A", "23/11/2020", "Larote – FuerteVentura",
  #      "10:20:00 PM", "5", "3", "Open"],
  #     ["4", "Sandra", "Brava 22 W.A", "23/11/2020", "Lanzarote – FuerteVentura",
  #      "10:20:00 PM", "5", "3", "Open"],
  #     ["8", "John", "Yamaha", "FromHereToThere", "TheLastOneWasDate", "aBlink", "5",
  #      "5", "Open"]
  #   ]

  # end
  #Falla

end
