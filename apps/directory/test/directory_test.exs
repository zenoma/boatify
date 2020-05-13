defmodule DirectoryTest do
  use ExUnit.Case
  doctest Directory

  test "inicio_y_parada", _value do
    {st, _pid} = Directory.levantar_servidor()
    assert st = :ok

    stop = Directory.parar_servidor()
    assert stop == :ok
  end

  test "inicio_y_parada_supervisada", _value do
    {st, _pid} = Directory.start()
    assert st = :ok

    stop = Directory.stop()
    assert stop == :ok
  end
end
