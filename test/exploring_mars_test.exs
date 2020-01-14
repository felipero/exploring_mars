defmodule ExploringMarsTest do
  use ExUnit.Case
  doctest ExploringMars

  test "config the plateau based on coordinates" do
    assert {:ok, %{x: 4, y: 5}} = ExploringMars.config_plateau(4, 5)
  end

  test "config the plateau with negative coordinates returns an error" do
    assert {:error, %{message: "coordinates need to be greater than zero."}} ==
             ExploringMars.config_plateau(-4, 5)

    assert {:error, %{message: "coordinates need to be greater than zero."}} ==
             ExploringMars.config_plateau(4, -5)
  end

  test "config the plateau with zeroed coordinates returns an error" do
    assert {:error, %{message: "coordinates need to be greater than zero."}} ==
             ExploringMars.config_plateau(0, 0)
  end
  end
end
