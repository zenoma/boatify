defmodule StowawayTest do
  use ExUnit.Case
  doctest Stowaway

  test "greets the world" do
    assert Stowaway.hello() == :world
  end
end
