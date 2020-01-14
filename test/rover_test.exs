defmodule RoverTest do
  use ExUnit.Case
  doctest Rover

  test "rotates to left and returns a the new rover positioning" do
    assert %Rover{x: 1, y: 2, direction: "E"} ==
             Rover.rotate("L", %Rover{x: 1, y: 2, direction: "S"})
  end

  test "rotate to right and returns a the new rover positioning" do
    assert %Rover{x: 1, y: 2, direction: "N"} ==
             Rover.rotate("R", %Rover{x: 1, y: 2, direction: "W"})
  end

  test "rotate returns an error for bad instruction" do
    assert {:error, message: "bad rotation instruction"} ==
             Rover.rotate("H", %Rover{x: 1, y: 2, direction: "W"})
  end

  test "move south returns the rover in the new position" do
    assert %Rover{x: 10, y: 9, direction: "S"} ==
             Rover.move(%Rover{x: 10, y: 10, direction: "S"})
  end

  test "move east returns the rover in the new position" do
    assert %Rover{x: 11, y: 10, direction: "E"} ==
             Rover.move(%Rover{x: 10, y: 10, direction: "E"})
  end

  test "move west returns the rover in the new position" do
    assert %Rover{x: 9, y: 10, direction: "W"} ==
             Rover.move(%Rover{x: 10, y: 10, direction: "W"})
  end

  test "move north returns the rover in the new position" do
    assert %Rover{x: 10, y: 11, direction: "N"} ==
             Rover.move(%Rover{x: 10, y: 10, direction: "N"})
  end
end
