defmodule Vectored.Elements.Polyline do
  @moduledoc """
  The `<polyline>` element is an SVG basic shape that creates straight lines
  connecting several points.

  Unlike `<polygon>`, a `<polyline>` is typically an open shape (the last point
  is not automatically connected to the first).

  ## Attributes

    * `points` - A list of `{x, y}` coordinates.
    * `path_length` - The total length of the polyline in user units.

  ## Examples

      iex> Vectored.Elements.Polyline.new([{0,0}, {20,20}, {40,0}, {60,20}])
      ...> |> Vectored.Elements.Polyline.with_fill("none")
      ...> |> Vectored.Elements.Polyline.with_stroke("blue")

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

  @doc """
  Create a new polyline with an optional list of points.
  """
  @spec new(list(point())) :: t()
  @spec new() :: t()
  def new(points \\ []) do
    %__MODULE__{points: points |> List.wrap()}
  end

  @doc """
  Append a point to the polyline.
  """
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
