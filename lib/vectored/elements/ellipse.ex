defmodule Vectored.Elements.Ellipse do
  @moduledoc """
  The `<ellipse>` element is an SVG basic shape used to draw ellipses.

  It is defined by a center point and two radii (horizontal and vertical).

  ## Attributes

    * `cx`, `cy` - The coordinates of the center of the ellipse.
    * `rx`, `ry` - The horizontal and vertical radii of the ellipse.
    * `path_length` - The total length of the ellipse's perimeter in user units.
      Must be a number.

  `cx`, `cy`, `rx` and `ry` are `<length-percentage>` values. Pass a number for
  user units, or a string for a percentage or CSS unit (`"50%"`, `"2em"`,
  `"10px"`). Percentages resolve against the viewport: `cx`/`rx` against its
  width, `cy`/`ry` against its height.

  ## Examples

      iex> Vectored.Elements.Ellipse.new(100, 50, 80, 40)
      ...> |> Vectored.Elements.Ellipse.with_fill("yellow")
      ...> |> Vectored.to_svg_string()
      {:ok, ~s|<ellipse cx="100" cy="50" fill="yellow" rx="80" ry="40"/>|}

      # An ellipse that stretches with its container
      iex> Vectored.Elements.Ellipse.new("50%", "50%", "40%", "25%")
      ...> |> Vectored.to_svg_string()
      {:ok, ~s|<ellipse cx="50%" cy="50%" rx="40%" ry="25%"/>|}

  """

  use Vectored.Elements.Element,
    attributes: [cx: 0, cy: 0, rx: 0, ry: 0, path_length: nil]

  @type t :: %__MODULE__{
          cx: String.t() | number() | nil,
          cy: String.t() | number() | nil,
          rx: String.t() | number(),
          ry: String.t() | number(),
          path_length: number() | nil
        }

  @doc """
  Create a new ellipse with horizontal and vertical radii.

  The center point defaults to (0,0).
  """
  @spec new(String.t() | number(), String.t() | number()) :: t()
  def new(rx, ry) do
    %__MODULE__{rx: rx, ry: ry}
  end

  @doc """
  Create a new ellipse with center point and radii.

  ## Parameters

    * `cx` - The x-coordinate of the center.
    * `cy` - The y-coordinate of the center.
    * `rx` - The horizontal radius.
    * `ry` - The vertical radius.
  """
  @spec new(
          String.t() | number(),
          String.t() | number(),
          String.t() | number(),
          String.t() | number()
        ) :: t()
  def new(cx, cy, rx, ry) do
    %__MODULE__{cx: cx, cy: cy, rx: rx, ry: ry}
  end

  @doc """
  Set the center location of the ellipse.
  """
  @spec at_location(t(), String.t() | number(), String.t() | number()) :: t()
  def at_location(ellipse, x, y) do
    %{ellipse | cx: x, cy: y}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Ellipse{} = element) do
      attrs = Vectored.Elements.Ellipse.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)
      {:ellipse, attrs, children}
    end
  end
end
