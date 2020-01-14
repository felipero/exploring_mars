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

end
