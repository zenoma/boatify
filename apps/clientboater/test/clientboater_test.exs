defmodule ClientboaterTest do
  use ExUnit.Case

  doctest Clientboater

  setup_all do
    {:ok, _boaterPID} = Boater.start(1)
    {:ok, _directoryPID} = Directory.start()
    {_value, :ok} = Clientboater.cliente_boater("BoaterTest")
    :ok
  end

  test "full_client_functions", _value do
    Clientboater.enviar_boater(1, ["ModeloTest", "FechaTest", "RutaTest", "HoraTest", "4"])
    Process.sleep(500)

    [id | info_trip] =
      "./Trip.csv"
      |> Path.expand()
      |> File.stream!()
      |> CSV.decode()
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.at(-1)

    assert Kernel.match?(info_trip, [
             "BoaterTest",
             "ModeloTest",
             "FechaTest",
             "RutaTest",
             "Hora",
             "4",
             "4",
             "Open"
           ])

    Clientboater.enviar_boater(3, id)
    Process.sleep(500)

    [idc | info_tripc] =
      "./Trip.csv"
      |> Path.expand()
      |> File.stream!()
      |> CSV.decode()
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.at(-1)

    assert Kernel.match?(info_trip, [
             "BoaterTest",
             "ModeloTest",
             "FechaTest",
             "RutaTest",
             "Hora",
             "4",
             "4",
             "Canceled"
           ])

    otra = Clientboater.enviar_boater(10)
    assert otra == {10, :ok}

    ver = Clientboater.enviar_boater(2)
    Process.sleep(500)
    assert ver == {2, :ok}

    chao = Clientboater.enviar_boater(4)
    assert chao == {4, :ok}
  end
end
