defmodule RoverTest do
  use ExUnit.Case
  doctest Rover

  describe "rotate" do
    test "to left and returns a the new rover positioning" do
      assert %Rover{x: 1, y: 2, direction: "E"} ==
               Rover.rotate("L", %Rover{x: 1, y: 2, direction: "S"})
    end

    test "to right and returns a the new rover positioning" do
      assert %Rover{x: 1, y: 2, direction: "N"} ==
               Rover.rotate("R", %Rover{x: 1, y: 2, direction: "W"})
    end

    test "returns an error for bad instruction" do
      assert {:error, message: "bad rotation instruction: H"} ==
               Rover.rotate("H", %Rover{x: 1, y: 2, direction: "W"})
    end
  end

  describe "move" do
    test "to south returns the rover in the new position" do
      assert %Rover{x: 10, y: 9, direction: "S"} ==
               Rover.move(%Rover{x: 10, y: 10, direction: "S"})
    end

    test "to east returns the rover in the new position" do
      assert %Rover{x: 11, y: 8, direction: "E"} ==
               Rover.move(%Rover{x: 10, y: 8, direction: "E"})
    end

    test "to west returns the rover in the new position" do
      assert %Rover{x: 4, y: 10, direction: "W"} ==
               Rover.move(%Rover{x: 5, y: 10, direction: "W"})
    end

    test "to north returns the rover in the new position" do
      assert %Rover{x: 10, y: 11, direction: "N"} ==
               Rover.move(%Rover{x: 10, y: 10, direction: "N"})
    end
  end

  describe "explore" do
    test "returns the rover with updated position" do
      assert %Rover{x: 9, y: 11, direction: "N"} ==
               Rover.explore(
                 %Rover{x: 10, y: 10, direction: "W"},
                 %{x: 100, y: 100},
                 ["M", "R", "M"]
               )
    end

    test "returns error when out of plateau" do
      assert {:error, %Rover{x: 10, y: 11, direction: "N"},
              message: "Rover got out of the plateau."}

      Rover.explore(%Rover{x: 10, y: 10, direction: "W"}, %{x: 100, y: 100}, ["R", "M"])
    end

    test "ignores invalid instructions" do
      assert %Rover{x: 9, y: 10, direction: "W"} ==
               Rover.explore(
                 %Rover{x: 10, y: 10, direction: "W"},
                 %{x: 100, y: 100},
                 ["A", "A", "A", "B", "M"]
               )
    end
  end

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

  describe "to_string" do
    test "returns the position and direction in a sequencial string" do
      assert "12 134 N" == to_string(%Rover{x: 12, y: 134, direction: "N"})
    end
  end
end
