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

  defimpl String.Chars, for: Rover do
    @doc """
    Converts Rover to a string

    ## Examples
        iex> to_string(%Rover{x: 3, y: 4, direction: "E"})
        "3 4 E"
    """
    def to_string(%Rover{x: x, y: y, direction: dir}), do: "#{x} #{y} #{dir}"
  end

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
      iex> Rover.explore(%Rover{x: 2, y: 2, direction: "N"}, %{x: 5, y: 5}, ["L","M","L","M", "L","M","L","M","M"])
      %Rover{x: 2, y: 3, direction: "N"}

      iex> Rover.explore(%Rover{x: 2, y: 2, direction: "N"}, %{x: 5, y: 5}, ["M","M","R","M","M","M"])
      %Rover{x: 5, y: 4, direction: "E"}

      iex> Rover.explore(%Rover{x: 2, y: 2, direction: "N"}, %{x: 5, y: 5}, ["M","M","M","M"])
      {:error, %Rover{x: 2, y: 6, direction: "N"}, %{x: 5, y: 5}, message: "Rover got out of the plateau."}
  """
  def explore(rover, plateau = %{x: plateau_x, y: plateau_y}, instructions) do
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
        {:error, rover, plateau, message: "Rover got out of the plateau."}

      _ ->
        rover
    end
  end

  defp process_instruction(rover, instruction) when instruction == "M",
    do: move(rover)

  defp process_instruction(rover, instruction) when instruction in ["L", "R"],
    do: rotate(instruction, rover)

  defp process_instruction(rover, _), do: rover

  @doc """
  Lands a rover inside the given `plateau` using the given coordinates `x` and `y`.
  If the positions are not valid (out of the `plateau` mesh, for example), it will return an error.

  ## Examples
      iex> Rover.land(%{x: 13, y: 2}, 12, 1, "N")
      {:ok, %Rover{x: 12, y: 1, direction: "N"}}

      iex> Rover.land(%{x: 13, y: 2}, 10, 8, "E")
      {:error, %Rover{x: 10, y: 8, direction: "E"}, %{x: 13, y: 2}, message: "Landed out of plateau."}
  """
  def land(%{x: xboundary, y: yboundary}, x, y, dir)
      when x in 0..xboundary and y in 0..yboundary and dir in ["N", "E", "W", "S"],
      do: {:ok, %Rover{x: x, y: y, direction: dir}}

  def land(plateau, x, y, dir),
    do: {:error, %Rover{x: x, y: y, direction: dir}, plateau, message: "Landed out of plateau."}
end
