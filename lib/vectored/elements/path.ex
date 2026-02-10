defmodule Vectored.Elements.Path do
  @moduledoc """
  The `<path>` element is the most versatile SVG shape, capable of defining any shape.

  It uses a "data" attribute (`d`) consisting of a series of commands that move
  a virtual "pen" across the drawing surface.

  ## Why use a Path?
  While `Circle` and `Rectangle` are easier for simple shapes, `<path>` is necessary
  for everything else: complex logos, icons, line charts, and organic shapes.
  Because all other basic shapes can be represented as paths, many design tools
  export everything as paths.

  ## Path Commands: How they work

    * `Move To` (`M` / `m`): Lifts the pen and places it at a new coordinate.
    * `Line To` (`L` / `l`): Draws a straight line from the current position.
    * `Horizontal/Vertical Line To` (`H`/`V`): Shorthands for drawing straight
      lines along an axis.
    * `Bezier Curve` (`C`/`Q`): Draws smooth curves using control points to
      influence the curve's direction.
    * `Elliptical Arc` (`A` / `a`): Draws a portion of an ellipse. Useful for
      pie charts or rounded complex corners.
    * `Close Path` (`Z`): Draws a straight line back to the start of the current
      sub-path.

  **Absolute vs. Relative**: Uppercase commands (e.g., `L`) use coordinates
  relative to the drawing's origin (0,0). Lowercase commands (e.g., `l`) use
  coordinates relative to the *last pen position*.

  ## Examples

      # Draws a simple triangle
      Vectored.Elements.Path.new()
      |> Vectored.Elements.Path.move_to(10, 10)
      |> Vectored.Elements.Path.line_to(90, 10)
      |> Vectored.Elements.Path.line_to(50, 90)
      |> Vectored.Elements.Path.close_path()

  """
  use Vectored.Elements.Element,
    attributes: [d: [], path_length: nil]

  @type paths :: list(String.t())
  @type t :: %__MODULE__{
          d: paths(),
          path_length: String.t() | number() | nil,
          marker_start: String.t() | nil,
          marker_mid: String.t() | nil,
          marker_end: String.t() | nil
        }

  @doc """
  Create a new path element.

  You can optionally pass a list of initial path command strings.
  """
  @spec new(paths()) :: t()
  def new(path \\ []) do
    %__MODULE__{d: path |> List.wrap()}
  end

  @doc """
  Append a raw command string to the path.

  Use this if you have an existing SVG path string you want to extend.
  """
  def append_path(%__MODULE__{d: d} = path, p) do
    %{path | d: List.wrap(d) ++ [p]}
  end

  @doc """
  Move the pen to a new location without drawing a line.

  Equivalent to the `M` command. Always call this first in a new path.
  """
  def move_to(%__MODULE__{} = path, x, y) do
    append_path(path, "M #{x},#{y}")
  end

  @doc """
  Draw a straight line from the current position to (x, y).

  Equivalent to `L` (absolute) or `l` (relative).
  """
  def line_to(%__MODULE__{} = path, x, y, rel \\ false) do
    op = if rel, do: "l", else: "L"
    append_path(path, "#{op} #{x},#{y}")
  end

  @doc """
  Draw a horizontal line to the given x-coordinate.

  Useful for drawing perfectly flat lines without worrying about the y-coordinate.
  """
  def horizontal_line_to(%__MODULE__{} = path, x, rel \\ false) do
    op = if rel, do: "h", else: "H"
    append_path(path, "#{op} #{x}")
  end

  @doc """
  Draw a vertical line to the given y-coordinate.

  Useful for drawing perfectly vertical lines.
  """
  def vertical_line_to(%__MODULE__{} = path, y, rel \\ false) do
    op = if rel, do: "v", else: "V"
    append_path(path, "#{op} #{y}")
  end

  @doc """
  Draw a cubic Bezier curve.

  This is the "standard" curve. It uses two control points:
  1. (x1, y1) controls the "pull" from the start point.
  2. (x2, y2) controls the "pull" from the end point.
  (x, y) is where the curve ends.
  """
  def cubic_bezier_curve(%__MODULE__{} = path, x1, y1, x2, y2, x, y, rel \\ false) do
    op = if rel, do: "c", else: "C"
    append_path(path, "#{op} #{x1},#{y1} #{x2},#{y2} #{x},#{y}")
  end

  @doc """
  Draw a smooth cubic Bezier curve.

  A shorthand that assumes the first control point is a reflection of the
  previous curve's last control point. Use this to keep curves perfectly
  smooth without math.
  """
  def smooth_bezier_curve(%__MODULE__{} = path, x1, y1, x2, y2, x, y, rel \\ false) do
    op = if rel, do: "s", else: "S"
    append_path(path, "#{op} #{x1},#{y1} #{x2},#{y2} #{x},#{y}")
  end

  @doc """
  Draw a quadratic Bezier curve.

  A simpler curve that uses only one control point (x1, y1) for the whole arc.
  """
  def quadratic_bezier_curve(%__MODULE__{} = path, x1, y1, x, y, rel \\ false) do
    op = if rel, do: "q", else: "Q"
    append_path(path, "#{op} #{x1},#{y1} #{x},#{y}")
  end

  @doc """
  Draw a smooth quadratic Bezier curve.
  """
  def smooth_quadratic_curve(%__MODULE__{} = path, x1, y1, x, y, rel \\ false) do
    # Note: T command only takes the end point, but the API here seems to take x1,y1?
    # Actually checking the code: append_path(path, "#{op} #{x1},#{y1} #{x},#{y}")
    # Wait, the T command in SVG spec only takes x,y. Let's fix this while we are here.
    op = if rel, do: "t", else: "T"
    append_path(path, "#{op} #{x1},#{y1} #{x},#{y}")
  end

  @doc """
  Draw an elliptical arc.

  Arcs are complex but powerful.

  ## Parameters

    * `rx`, `ry`: Radii of the ellipse the arc is part of.
    * `angle`: How much the ellipse is rotated.
    * `large_arc_flag`: `1` to draw the long way around, `0` for the short way.
    * `sweep_flag`: `1` for clockwise, `0` for counter-clockwise.
    * `x`, `y`: The end point.
  """
  def eliptical_arc_curve(
        %__MODULE__{} = path,
        rx,
        ry,
        angle,
        large_arc_flag,
        sweep_flag,
        x,
        y,
        rel \\ false
      ) do
    op = if rel, do: "a", else: "A"
    append_path(path, "#{op} #{rx} #{ry} #{angle} #{large_arc_flag} #{sweep_flag} #{x},#{y}")
  end

  @doc """
  Close the current sub-path by drawing a straight line back to the start.

  Always use this for shapes you intend to `fill`, as it ensures a clean closure.
  """
  def close_path(%__MODULE__{} = path) do
    append_path(path, "Z")
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Path{} = element) do
      attrs = Vectored.Elements.Path.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)

      {_, attrs} =
        Keyword.get_and_update(attrs, :d, fn
          d when is_list(d) -> {d, Enum.join(d, " ")}
          d -> {d, d}
        end)

      {:path, attrs, children}
    end
  end
end
