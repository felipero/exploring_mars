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
    assert {:ok, %{x_pos: 2, y_pos: 3}} == ExploringMars.position_rover(%{x: 4, y: 5}, 2, 3)
  end

  test "position_rover with invalid coordinates returns an error with the positions and the plateau" do
    assert {:error, %{x_pos: 12, y_pos: 3}, %{x: 4, y: 5}} ==
             ExploringMars.position_rover(%{x: 4, y: 5}, 12, 3)
  end

  test "position_rover with zeroed coordinates returns the rover position" do
    assert {:ok, %{x_pos: 0, y_pos: 3}} ==
             ExploringMars.position_rover(%{x: 4, y: 5}, 0, 3)
  end

  test "position_rover with negative coordinates returns an error with the positions and the plateau" do
    assert {:error, %{x_pos: 2, y_pos: -3}, %{x: 4, y: 5}} ==
             ExploringMars.position_rover(%{x: 4, y: 5}, 2, -3)
  end
end
