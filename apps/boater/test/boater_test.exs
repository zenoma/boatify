defmodule BoaterTest do
  use ExUnit.Case
  doctest Boater

  test "levantar_servidor" do
   {_,pid} = Boater.levantar_servidor(:Sandra)
   assert Process.alive?(pid) ==  true
  end

  test "parar_servidor" do
    {_,pid} = Boater.levantar_servidor(:Sandra)
    Boater.parar_servidor(:Sandra)
    assert Process.alive?(pid) ==  false
  end

  test "start" do
    Boater.start(1)
  end

  test "stop" do
    Boater.start(1)
    Boater.stop
  end
end
