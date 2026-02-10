defmodule Vectored.Elements.Circle do
  @moduledoc """
  The `<circle>` element is an SVG basic shape used to draw circles.

  A circle is defined by its center point (`cx`, `cy`) and its radius (`r`).

  ## Attributes

    * `cx`, `cy` - The center of the circle. If omitted, the circle's center
      is at the top-left (0,0) of the current coordinate system.
    * `r` - The radius. This determines the size. If the SVG has a `view_box`,
      this value is relative to that coordinate system.
    * `path_length` - An optional attribute to "recalibrate" the length of
      the circle's perimeter, useful for dashed-line animations.

  ## Why use a Circle?
  While you could draw a circle using a `<path>`, the `<circle>` element is
  much easier to read, write, and manipulate programmatically when you just
  need a simple round shape.

  ## Examples

      # Draws a red circle with a 40-unit radius
      Vectored.Elements.Circle.new(40)
      |> Vectored.Elements.Circle.with_fill("red")

  """

  use Vectored.Elements.Element,
    attributes: [cx: 0, cy: 0, r: 0, path_length: nil]

  @type t :: %__MODULE__{
          cx: String.t() | number() | nil,
          cy: String.t() | number() | nil,
          r: String.t() | number(),
          path_length: number() | nil
        }

  @doc """
  Create a new circle with a radius.

  The center point defaults to (0,0). Use this when you plan to position
  the circle later using `at_location/3` or by wrapping it in a `<g>` with
  a transform.
  """
  @spec new(String.t() | number()) :: t()
  def new(r) do
    %__MODULE__{r: r}
  end

  @doc """
  Create a new circle with a center point and radius.

  This is the most common way to create a circle when you already know
  where it should sit in your coordinate system.
  """
  @spec new(String.t() | number(), String.t() | number(), String.t() | number()) :: t()
  def new(x, y, r) do
    %__MODULE__{cx: x, cy: y, r: r}
  end

  @doc """
  Set the center location of the circle.

  Useful for moving a circle dynamically based on calculation or data.
  """
  @spec at_location(t(), number(), number()) :: t()
  def at_location(circle, x, y) do
    %{circle | cx: x, cy: y}
  end

  @doc """
  Set the radius of the circle.

  Values are in user units. If your SVG `view_box` is `0 0 100 100`,
  a radius of `50` will make the circle touch the edges of the box.
  """
  def with_radius(circle, r) do
    %{circle | r: r}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Circle{} = element) do
      attrs = Vectored.Elements.Circle.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)
      {:circle, attrs, children}
    end
  end
end
