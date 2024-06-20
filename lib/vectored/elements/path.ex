defmodule Vectored.Elements.Path do
  @moduledoc """
  d
  This attribute defines the shape of the path. Value type: <string> ; Default value: ''; Animatable: yes

  path_length
  This attribute lets authors specify the total length for the path, in user units. Value type: <number> ; Default value: none; Animatable: yes
  """
  use Vectored.Elements.Element,
    attributes: [d: [], path_length: nil, marker_start: nil, marker_end: nil, marker_mid: nil],
    attribute_overrides: [marker_start: :"marker-start", marker_end: :"marker-end", marker_mid: :"marker-mid"]

  @type paths :: list(String.t())
  @type t :: %__MODULE__{
    d: paths(),
    path_length: String.t() | number() | nil,
    marker_start: String.t() | nil,
    marker_mid: String.t() | nil,
    marker_end: String.t() | nil,
  }

  @spec new(paths()) :: t()
  def new(path \\ []) do
    %__MODULE__{d: path |> List.wrap()}
  end

  def append_path(%__MODULE__{d: d} = path, p) do
    %{path | d: List.wrap(d) ++ [p]}
  end

  def move_to(%__MODULE__{} = path, x, y) do
    append_path(path, "M #{x},#{y}")
  end

  def line_to(%__MODULE__{} = path, x, y, rel \\ false) do
    op = if rel, do: "l", else: "L"
    append_path(path, "#{op} #{x},#{y}")
  end

  def horizontal_line_to(%__MODULE__{} = path, x, rel \\ false) do
    op = if rel, do: "h", else: "H"
    append_path(path, "#{op} #{x}")
  end

  def vertical_line_to(%__MODULE__{} = path, y, rel \\ false) do
    op = if rel, do: "v", else: "V"
    append_path(path, "#{op} #{y}")
  end

  def cubic_bezier_curve(%__MODULE__{} = path, x1, y1, x2, y2, x, y, rel \\ false) do
    op = if rel, do: "c", else: "C"
    append_path(path, "#{op} #{x1},#{y1} #{x2},#{y2} #{x},#{y}")
  end

  def smooth_bezier_curve(%__MODULE__{} = path, x1, y1, x2, y2, x, y, rel \\ false) do
    op = if rel, do: "s", else: "S"
    append_path(path, "#{op} #{x1},#{y1} #{x2},#{y2} #{x},#{y}")
  end

  def quadratic_bezier_curve(%__MODULE__{} = path, x1, y1, x, y, rel \\ false) do
    op = if rel, do: "q", else: "Q"
    append_path(path, "#{op} #{x1},#{y1} #{x},#{y}")
  end

  def smooth_quadratic_curve(%__MODULE__{} = path, x1, y1, x, y, rel \\ false) do
    op = if rel, do: "t", else: "T"
    append_path(path, "#{op} #{x1},#{y1} #{x},#{y}")
  end

  def eliptical_arc_curve(%__MODULE__{} = path, rx, ry, angle, large_arc_flag, sweep_flag, x, y, rel \\ false) do
    op = if rel, do: "a", else: "A"
    append_path(path, "#{op} #{rx} #{ry} #{angle} #{large_arc_flag} #{sweep_flag} #{x},#{y}")
  end

  def close_path(%__MODULE__{} = path) do
    append_path(path, "Z")
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
