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

  test "position_rover with valid coordinates returns the rover position" do
    assert {:ok, %Rover{x: 2, y: 3, direction: "N"}} ==
             ExploringMars.position_rover(%{x: 4, y: 5}, 2, 3, "N")
  end

  test "position_rover with invalid coordinates returns an error with the positions and the plateau" do
    assert {:error, %Rover{x: 12, y: 3, direction: "E"}, %{x: 4, y: 5}} ==
             ExploringMars.position_rover(%{x: 4, y: 5}, 12, 3, "E")
  end

  test "position_rover with zeroed coordinates returns the rover position" do
    assert {:ok, %Rover{x: 0, y: 3, direction: "W"}} ==
             ExploringMars.position_rover(%{x: 4, y: 5}, 0, 3, "W")
  end

  test "position_rover with negative coordinates returns an error with the positions and the plateau" do
    assert {:error, %Rover{x: 2, y: -3, direction: "S"}, %{x: 4, y: 5}} ==
             ExploringMars.position_rover(%{x: 4, y: 5}, 2, -3, "S")
  end

  test "position_rover with invalid direction returns an error with the positions and the plateau" do
    assert {:error, %Rover{x: 2, y: 3, direction: "R"}, %{x: 4, y: 5}} ==
             ExploringMars.position_rover(%{x: 4, y: 5}, 2, 3, "R")
  end
end
