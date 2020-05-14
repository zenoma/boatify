defmodule ClientstowawayTest do
  use ExUnit.Case
  doctest Clientstowaway

  setup_all do
    {:ok, _boaterPID} = Boater.start(1)
    {:ok, _boaterPID} = Stowaway.start(1)
    {:ok, _directoryPID} = Directory.start()
    {_value, :ok} = Clientstowaway.cliente_stowaway("StowerTest")
    :ok
  end

  test "full_client_functions", _value do
    # Ver viajes disponibles 

    disp = Clientstowaway.enviar_stowaway(1)
    Process.sleep(500)
    assert disp == {1, :ok}

    # Reservar viaje         

    trip_disp_before =
      "./Trip.csv"
      |> Path.expand()
      |> File.stream!()
      |> CSV.decode()
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.at(8)
      |> Enum.at(7)
      |> String.to_integer()

    Clientstowaway.enviar_stowaway(2, "8")
    Process.sleep(500)

    trip_disp_after =
      "./Trip.csv"
      |> Path.expand()
      |> File.stream!()
      |> CSV.decode()
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.at(8)
      |> Enum.at(7)
      |> String.to_integer()

    assert trip_disp_before > trip_disp_after

    record =
      "./Record.csv"
      |> Path.expand()
      |> File.stream!()
      |> CSV.decode()
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.at(-1)

    assert record == ["8", "StowerTest", "1", "Open"]

    # Ver mis viajes 

    mine = Clientstowaway.enviar_stowaway(3)
    Process.sleep(500)
    assert mine == {3, :ok}

    # Cancelar viaje

    trip_disp_before =
      "./Trip.csv"
      |> Path.expand()
      |> File.stream!()
      |> CSV.decode()
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.at(8)
      |> Enum.at(7)
      |> String.to_integer()

    Clientstowaway.enviar_stowaway(4, "8")
    Process.sleep(500)

    trip_disp_after =
      "./Trip.csv"
      |> Path.expand()
      |> File.stream!()
      |> CSV.decode()
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.at(8)
      |> Enum.at(7)
      |> String.to_integer()

    assert trip_disp_before != trip_disp_after

    record =
      "./Record.csv"
      |> Path.expand()
      |> File.stream!()
      |> CSV.decode()
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.at(-1)

    assert record == ["8", "StowerTest", "1", "Canceled"]

    # Cerrar

    chao = Clientstowaway.enviar_stowaway(5)
    assert chao == {5, :ok}
  end
end
