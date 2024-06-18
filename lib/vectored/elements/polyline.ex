defmodule Vectored.Elements.Polyline do
  @moduledoc """
  points
  This attribute defines the list of points (pairs of x,y absolute coordinates) required to draw the polyline Value type: <number>+ ; Default value: ""; Animatable: yes

  path_length
  This attribute lets specify the total length for the path, in user units. Value type: <number> ; Default value: none; Animatable: yes
  """
  use Vectored.Elements.Element,
    attributes: [points: [], path_length: nil, marker_start: nil, marker_end: nil, marker_mid: nil],
    attribute_overrides: [marker_start: :"marker-start", marker_end: :"marker-end", marker_mid: :"marker-mid"]

  @type point :: {number(), number()}

  @spec new(list(point())) :: t()
  def new(points \\ []) do
    %__MODULE__{points: points |> List.wrap()}
  end

  @spec append_points(t(), point()) :: t()
  def append_points(%__MODULE__{points: points} = path, point) do
    %{path | points: List.wrap(points) ++ [point]}
  end

  def with_marker_start(path, ref) do
    %{path | marker_start: ref}
  end

  def with_marker_mid(path, ref) do
    %{path | marker_mid: ref}
  end

  def with_marker_end(path, ref) do
    %{path | marker_end: ref}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Polyline{} = element) do
      attrs = Vectored.Elements.Polyline.attributes(element)
      {_, attrs} =
        Keyword.get_and_update(attrs, :points, fn 
          points-> 
            points_str =
              points
              |> Enum.map(fn {x, y} -> "#{x},#{y}" end)
              |> Enum.join(" ")
            {points, points_str}
        end)

      {:polyline, attrs, []}
    end
  end
end
