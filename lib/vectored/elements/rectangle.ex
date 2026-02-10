defmodule Vectored.Elements.Rectangle do
  @moduledoc """
  The `<rect>` element is an SVG basic shape used to create rectangles.

  ## Attributes

    * `x`, `y` - The coordinates of the top-left corner. Defaults to (0,0).
    * `width`, `height` - Dimensions of the rectangle.
    * `rx`, `ry` - Corner radii for rounding. If you set `rx: 5`, all four
      corners will have a 5-unit radius. If you set both, you can create
      elliptical corners.
    * `path_length` - Recalibrates the total perimeter length for dashed-line
      animations.

  ## Why use a Rectangle?
  Rectangles are the building blocks for many UI elements in SVG, from
  simple bars in a chart to complex buttons. Using `<rect>` instead of
  a `<path>` makes it easy to change the width/height or rounding radius
  without recalculating coordinates.

  ## Examples

      # A 100x50 blue box with rounded corners
      Vectored.Elements.Rectangle.new(10, 10, 100, 50)
      |> Vectored.Elements.Rectangle.with_fill("blue")
      |> Vectored.Elements.Rectangle.with_rx(8)

  """

  use Vectored.Elements.Element,
    attributes: [rx: nil, ry: nil, path_length: nil]

  @type t :: %__MODULE__{
          x: String.t() | number(),
          y: String.t() | number(),
          width: String.t() | number() | nil,
          height: String.t() | number() | nil,
          rx: String.t() | number() | nil,
          ry: String.t() | number() | nil,
          path_length: String.t() | nil
        }

  @doc """
  Create an empty rectangle.
  """
  @spec new() :: t()
  def new() do
    %__MODULE__{}
  end

  @doc """
  Create a rectangle with specified position and dimensions.
  """
  @spec new(number(), number(), number(), number()) :: t()
  def new(x, y, width, height) do
    %__MODULE__{x: x, y: y, width: width, height: height}
  end

  @doc """
  Set the top-left corner location.
  """
  @spec at_location(t(), String.t() | number(), String.t() | number()) :: t()
  def at_location(rectangle, x, y) do
    %{rectangle | x: x, y: y}
  end

  @doc """
  Set the dimensions.

  Units are relative to the current coordinate system or `view_box`.
  """
  def with_size(rectangle, width, height) do
    %{rectangle | width: width, height: height}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Rectangle{} = element) do
      attrs = Vectored.Elements.Rectangle.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)
      {:rect, attrs, children}
    end
  end
end
