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
    assert {:error, message: "bad rotation instruction: H"} ==
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

  describe "explore" do
    test "returns the rover with updated position" do
      assert %Rover{x: 9, y: 11, direction: "N"} ==
               Rover.explore(%Rover{x: 10, y: 10, direction: "W"}, %{x: 100, y: 100}, "MRM")
    end

    test "returns error when out of plateau" do
      assert {:error, %Rover{x: 10, y: 11, direction: "N"},
              message: "Rover got out of the plateau."}

      Rover.explore(%Rover{x: 10, y: 10, direction: "W"}, %{x: 100, y: 100}, "RM")
    end

    test "ignores invalid instructions" do
      assert %Rover{x: 9, y: 10, direction: "W"} ==
               Rover.explore(%Rover{x: 10, y: 10, direction: "W"}, %{x: 100, y: 100}, "AAABM")

  describe "land" do
    test "land with valid coordinates returns the rover position" do
      assert {:ok, %Rover{x: 2, y: 3, direction: "N"}} ==
               Rover.land(%{x: 4, y: 5}, 2, 3, "N")
    end

    test "land with invalid coordinates returns an error with the positions and the plateau" do
      assert {:error, %Rover{x: 12, y: 3, direction: "E"}, %{x: 4, y: 5},
              message: "Landed out of plateau."} ==
               Rover.land(%{x: 4, y: 5}, 12, 3, "E")
    end

    test "land with zeroed coordinates returns the rover position" do
      assert {:ok, %Rover{x: 0, y: 3, direction: "W"}} ==
               Rover.land(%{x: 4, y: 5}, 0, 3, "W")
    end

    test "land with negative coordinates returns an error with the positions and the plateau" do
      assert {:error, %Rover{x: 2, y: -3, direction: "S"}, %{x: 4, y: 5},
              message: "Landed out of plateau."} ==
               Rover.land(%{x: 4, y: 5}, 2, -3, "S")
    end

    test "land with invalid direction returns an error with the positions and the plateau" do
      assert {:error, %Rover{x: 2, y: 3, direction: "R"}, %{x: 4, y: 5},
              message: "Landed out of plateau."} ==
               Rover.land(%{x: 4, y: 5}, 2, 3, "R")
    end
  end
    end
  end
end
