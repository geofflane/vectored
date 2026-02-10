defmodule Vectored.Elements.Polygon do
  @moduledoc """
  The <polygon> element defines a closed shape consisting of a set of connected straight line segments. The last point is connected to the first point.

  points
  This attribute defines the list of points (pairs of x,y absolute coordinates) required to draw the polyline Value type: <number>+ ; Default value: ""; Animatable: yes

  path_length
  This attribute lets specify the total length for the path, in user units. Value type: <number> ; Default value: none; Animatable: yes
  """
  use Vectored.Elements.Element,
    attributes: [points: [], path_length: nil]

  @type point :: {number(), number()}
  @type t :: %__MODULE__{
          points: list(point()),
          path_length: String.t() | number() | nil
        }

  @spec new(list(point())) :: t()
  @spec new() :: t()
  def new(points \\ []) do
    %__MODULE__{points: points |> List.wrap()}
  end

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
