defmodule ExploringMars do
  @moduledoc """
  Documentation for ExploringMars.
  """
  require Logger

  def main(_) do
    File.stream!("instructions.txt")
    |> Stream.map(&String.split(&1, ["\n", " "], trim: true))
    |> Enum.to_list()
    |> process_rovers
  end

  def process_rovers([head | tail]) do
    {:ok, plateau} = Kernel.apply(&config_plateau/2, Enum.map(head, &String.to_integer(&1)))

    tail
    |> Enum.chunk_every(2)
    |> Enum.map(fn rover_set ->
      case process_rover(rover_set, plateau) do
        {:error, rover, plateau, [message: msg]} ->
          Logger.error("ERROR: #{msg} -> #{rover} with plateau #{inspect(plateau)}")
          "ERROR: #{msg} -> #{rover} with plateau #{inspect(plateau)}"

        rover ->
          to_string(rover)
      end
    end)
  end

  @doc """
  Creates the plateau mesh based on the given coordinates `x` and `y`.
  The inferior left is always (0,0).

  ## Examples

      iex> ExploringMars.config_plateau(2, 3)
      {:ok, %{x: 2, y: 3}}

      iex> ExploringMars.config_plateau(-1, -5)
      {:error, %{message: "coordinates need to be greater than zero."}}
  """
  def config_plateau(x, y) when x > 0 and y > 0, do: {:ok, %{x: x, y: y}}

  def config_plateau(_, _), do: {:error, %{message: "coordinates need to be greater than zero."}}

  @doc """
  Process a list containing the positions and the instructions for a Rover.

  ## Examples
      iex> ExploringMars.process_rover([["6", "4", "N"], ["LLMM"]], %{x: 10, y: 10})
      %Rover{x: 6, y: 2, direction: "S"}

      iex> ExploringMars.process_rover([["13", "2", "E"], ["LLMM"]], %{x: 5, y: 5})
      {:error, %Rover{x: 13, y: 2, direction: "E"}, %{x: 5, y: 5}, message: "Landed out of plateau."}

      iex> ExploringMars.process_rover([["2", "2", "N"], ["MMMM"]], %{x: 5, y: 5})
      {:error, %Rover{x: 2, y: 6, direction: "N"}, %{x: 5, y: 5}, message: "Rover got out of the plateau."}
  """
  def process_rover([[xs, ys, dir], [instructions]], plateau) do
    case Rover.land(plateau, String.to_integer(xs), String.to_integer(ys), dir) do
      {:ok, rover} ->
        rover |> Rover.explore(plateau, String.split(instructions, "", trim: true))

      error ->
        error
    end
  end
end
