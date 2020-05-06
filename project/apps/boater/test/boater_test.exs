defmodule BoaterTest do
  use ExUnit.Case
  doctest Boater

  test "levantar_servidor" do
   {_,pid} = Boater.levantar_servidor()
   assert Process.alive?(pid) ==  true
  end
end
