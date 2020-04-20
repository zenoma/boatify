defmodule BoaterTest do
  use ExUnit.Case
  doctest Boater

  test "greets the world" do
    assert Boater.hello() == :world
  end
end
