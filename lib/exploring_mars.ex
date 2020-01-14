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
  Positions a rover inside the given `plateau` using the given coordinates `x_pos` and `y_pos`.
  If the positions are not valid (out of the `plateau` mesh, for example), it will return an error.

  ## Examples
      iex> ExploringMars.position_rover(%{x: 13, y: 2}, 12, 1)
      {:ok, %{x_pos: 12, y_pos: 1}}

      iex> ExploringMars.position_rover(%{x: 13, y: 2}, 10, 8)
      {:error, %{x_pos: 10, y_pos: 8}, %{x: 13, y: 2}}
  """
  def position_rover(%{x: right_boundary, y: top_boundary}, x_pos, y_pos)
      when x_pos in 0..right_boundary and y_pos in 0..top_boundary,
      do: {:ok, %{x_pos: x_pos, y_pos: y_pos}}

  def position_rover(%{x: right_boundary, y: top_boundary}, x_pos, y_pos),
    do: {:error, %{x_pos: x_pos, y_pos: y_pos}, %{x: right_boundary, y: top_boundary}}
end
