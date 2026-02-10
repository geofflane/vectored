defmodule Vectored.Elements.Polygon do
  @moduledoc """
  The `<polygon>` element defines a closed shape consisting of a set of connected
  straight line segments.

  The last point is automatically connected back to the first point to close the shape.

  ## Attributes

    * `points` - A list of `{x, y}` coordinates.
    * `path_length` - The total length of the polygon's perimeter in user units.

  ## Examples

      iex> Vectored.Elements.Polygon.new([{0,0}, {50,0}, {25,50}])
      ...> |> Vectored.Elements.Polygon.with_fill("purple")

  """
  use Vectored.Elements.Element,
    attributes: [points: [], path_length: nil]

  @type point :: {number(), number()}
  @type t :: %__MODULE__{
          points: list(point()),
          path_length: String.t() | number() | nil
        }

  @doc """
  Create a new polygon with an optional list of points.
  """
  @spec new(list(point())) :: t()
  @spec new() :: t()
  def new(points \\ []) do
    %__MODULE__{points: points |> List.wrap()}
  end

  @doc """
  Append a point to the polygon.
  """
  @spec append_points(t(), point()) :: t()
  def append_points(%__MODULE__{points: points} = path, point) do
    %{path | points: List.wrap(points) ++ [point]}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Polygon{} = element) do
      attrs = Vectored.Elements.Polygon.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)

      {_, attrs} =
        Keyword.get_and_update(attrs, :points, fn
          points ->
            points_str =
              points
              |> Enum.map(fn {x, y} -> "#{x},#{y}" end)
              |> Enum.join(" ")

            {points, points_str}
        end)

      {:polygon, attrs, children}
    end
  end
end
