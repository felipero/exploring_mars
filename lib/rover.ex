defmodule Rover do
  require Logger

  @moduledoc """
    Module to represent the rover that will explore mars.
  """
  @enforce_keys [:x, :y, :direction]
  defstruct [:x, :y, :direction]

  @type t() :: %Rover{
          x: integer,
          y: integer,
          direction: String.t()
        }

  @doc """
  Rotates the rover.

  ## Examples
      iex> Rover.rotate("L", %Rover{x: 2, y: 3, direction: "N"})
      %Rover{x: 2, y: 3, direction: "W"}
      
      iex> Rover.rotate("R", %Rover{x: 2, y: 3, direction: "S"})
      %Rover{x: 2, y: 3, direction: "W"}

      iex> Rover.rotate("P", %Rover{x: 2, y: 3, direction: "S"})
      {:error, message: "bad rotation instruction: P"}
  """
  def rotate(rotation, rover) when rotation in ["L", "R"] do
    new_dir =
      %{
        "N" => %{"L" => "W", "R" => "E"},
        "E" => %{"L" => "N", "R" => "S"},
        "S" => %{"L" => "E", "R" => "W"},
        "W" => %{"L" => "S", "R" => "N"}
      }[rover.direction][rotation]

    %{rover | direction: new_dir}
  end

  def rotate(rotation, _), do: {:error, message: "bad rotation instruction: #{rotation}"}

  @doc """
  Move is used to move the rover to a new position in the plateau, in the rover's direction.

  ## Examples
      iex> Rover.move(%Rover{x: 1, y: 1, direction: "N"})
      %Rover{x: 1, y: 2, direction: "N"}
  """
  def move(rover) do
    case rover.direction do
      "N" -> %{rover | y: rover.y + 1}
      "E" -> %{rover | x: rover.y + 1}
      "S" -> %{rover | y: rover.y - 1}
      "W" -> %{rover | x: rover.y - 1}
    end
  end

  @doc """
  Explore a plateau by processing a sequence of instructions from a string.

  ## Examples
      iex> Rover.explore(%Rover{x: 2, y: 2, direction: "N"}, %{x: 5, y: 5}, "LMLMLMLMM")
      %Rover{x: 2, y: 3, direction: "N"}

      iex> Rover.explore(%Rover{x: 2, y: 2, direction: "N"}, %{x: 5, y: 5}, "MMRMMM")
      %Rover{x: 5, y: 4, direction: "E"}

      iex> Rover.explore(%Rover{x: 2, y: 2, direction: "N"}, %{x: 5, y: 5}, "MMMM")
      {:error, %Rover{x: 2, y: 6, direction: "N"}, message: "Rover got out of the plateau."}
  """
  def explore(rover, %{x: plateau_x, y: plateau_y}, instructions) do
    instructions = String.split(instructions, "", trim: true)

    rover =
      Enum.reduce(instructions, rover, fn instruction, rover ->
        case(process_instruction(rover, instruction)) do
          {:error, message: msg} ->
            Logger.error("Failed to process instruction: #{msg}")
            rover

          %Rover{} = new_rover ->
            new_rover
        end
      end)

    case rover do
      %Rover{x: x, y: y} when x > plateau_x or y > plateau_y ->
        {:error, rover, message: "Rover got out of the plateau."}

      _ ->
        rover
    end
  end

  defp process_instruction(rover, instruction) when instruction == "M",
    do: move(rover)

  defp process_instruction(rover, instruction) when instruction in ["L", "R"],
    do: rotate(instruction, rover)

  defp process_instruction(rover, _), do: rover
end
