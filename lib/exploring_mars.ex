defmodule ExploringMars do
  @moduledoc """
  Documentation for ExploringMars.
  """

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
  Positions a rover inside the given `plateau` using the given coordinates `x` and `y`.
  If the positions are not valid (out of the `plateau` mesh, for example), it will return an error.

  ## Examples
      iex> ExploringMars.position_rover(%{x: 13, y: 2}, 12, 1, "N")
      {:ok, %Rover{x: 12, y: 1, direction: "N"}}

      iex> ExploringMars.position_rover(%{x: 13, y: 2}, 10, 8, "E")
      {:error, %Rover{x: 10, y: 8, direction: "E"}, %{x: 13, y: 2}}
  """
  def position_rover(%{x: right_boundary, y: top_boundary}, x, y, dir)
      when x in 0..right_boundary and y in 0..top_boundary and dir in ["N", "E", "W", "S"],
      do: {:ok, %Rover{x: x, y: y, direction: dir}}

  def position_rover(%{x: right_boundary, y: top_boundary}, x, y, dir),
    do: {:error, %Rover{x: x, y: y, direction: dir}, %{x: right_boundary, y: top_boundary}}
end
