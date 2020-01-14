defmodule Rover do
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
      {:error, message: "bad rotation instruction"}
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

  def rotate(_, _), do: {:error, message: "bad rotation instruction"}

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
end
