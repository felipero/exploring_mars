defmodule ExploringMarsTest do
  use ExUnit.Case
  doctest ExploringMars

  test "greets the world" do
    assert ExploringMars.hello() == :world
  end
end
