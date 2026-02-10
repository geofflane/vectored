defmodule Vectored.Elements.Polyline do
  @moduledoc """
  The <polyline> SVG element is an SVG basic shape that creates straight lines connecting several points. Typically a polyline is used to create open shapes as the last point doesn't have to be connected to the first point.

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
          path_length: String.t() | number() | nil,
          marker_start: String.t() | nil,
          marker_mid: String.t() | nil,
          marker_end: String.t() | nil
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
    def to_svg(%Vectored.Elements.Polyline{} = element) do
      attrs = Vectored.Elements.Polyline.attributes(element)
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

      {:polyline, attrs, children}
    end
  end
end
