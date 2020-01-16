defmodule ExploringMarsTest do
  use ExUnit.Case
  doctest ExploringMars

  describe "config_plateau/2" do
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

  describe "process_rover/2" do
    test "returns the error when landing out of plateau " do
      assert {:error, %Rover{x: 2, y: 6, direction: "N"}, %{x: 5, y: 5},
              [message: "Landed out of plateau."]} ==
               ExploringMars.process_rover([["2", "6", "N"], ["LRLR"]], %{x: 5, y: 5})
    end

    test "returns the rover with the final positions" do
      assert %Rover{x: 6, y: 2, direction: "S"} ==
               ExploringMars.process_rover([["6", "4", "N"], ["LLMM"]], %{x: 10, y: 10})
    end

    test "returns an error when moving out of plateau" do
      assert {:error, %Rover{x: 2, y: 6, direction: "N"}, %{x: 5, y: 5},
              [message: "Rover got out of the plateau."]} ==
               ExploringMars.process_rover([["2", "2", "N"], ["MMMM"]], %{x: 5, y: 5})
    end
  end

  describe "process_rovers/1" do
    test "configs the plateau and return the rover with correct position" do
      assert ["2 3 S"] ==
               ExploringMars.process_rovers([["4", "4"], ["1", "3", "E"], ["MR"]])
    end

    test "configs the plateau and ignores error for rovers" do
      assert ["ERROR: Landed out of plateau. -> 1 13 E with plateau %{x: 4, y: 4}", "4 2 E"] ==
               ExploringMars.process_rovers([
                 ["4", "4"],
                 ["1", "13", "E"],
                 ["MR"],
                 ["4", "3", "E"],
                 ["RML"]
               ])
    end
  end
end
