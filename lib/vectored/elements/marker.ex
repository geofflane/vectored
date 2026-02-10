defmodule Vectored.Elements.Marker do
  @moduledoc """
  The `<marker>` element defines graphics (like arrowheads) that can be 
  attached to the start, middle, or end of a path or line.

  ## Why use a Marker?
  Instead of drawing an arrowhead at the end of every line manually, you 
  define a marker once and attach it using the `marker_end` attribute.

    * **Automatic Alignment**: Use `orient="auto"` and the arrowhead will 
      automatically rotate to point in the direction of the line.
    * **Reusable Components**: Change the marker's color or shape in one 
      place, and every arrow in your drawing updates.
    * **Dynamic Lines**: If you move the endpoint of a line, the attached 
      marker moves and rotates with it perfectly.

  ## Attributes

    * `marker_width`, `marker_height` - The dimensions of the marker's viewport.
    * `ref_x`, `ref_y` - The "anchor point" of the marker. For an arrowhead, 
      this is usually the tip.
    * `orient` - Set to `"auto"` to align with the line, or a fixed angle.

  ## Examples

      # Define a triangular arrowhead
      arrow = Vectored.Elements.Path.new() 
      |> Vectored.Elements.Path.move_to(0, 0)
      |> Vectored.Elements.Path.line_to(10, 5)
      |> Vectored.Elements.Path.line_to(0, 10)
      |> Vectored.Elements.Path.close_path()

      marker = Vectored.Elements.Marker.new()
      |> Vectored.Elements.Marker.with_shape(arrow)
      |> Vectored.Elements.Marker.size(10, 10)
      |> Vectored.Elements.Marker.ref(10, 5) # Point is at the tip
      |> Vectored.Elements.Marker.orient("auto")
      |> Vectored.Elements.Marker.with_id("arrowhead")

      # Use it on a line
      Vectored.Elements.Line.new()
      |> Vectored.Elements.Line.from(0, 0)
      |> Vectored.Elements.Line.to(100, 100)
      |> Vectored.Elements.Line.with_marker_end("url(#arrowhead)")

  """

  use Vectored.Elements.Element,
    attributes: [
      marker_height: 3,
      marker_units: nil,
      marker_width: 3,
      orient: 0,
      preserve_aspect_ratio: nil,
      ref_x: 0,
      ref_y: 0,
      view_box: nil,
      children: []
    ],
    attribute_overrides: [
      marker_height: :markerHeight,
      marker_width: :markerWidth,
      marker_units: :markerUnits,
      ref_x: :refX,
      ref_y: :refY
    ]

  @type t :: %__MODULE__{
          marker_height: number(),
          marker_units: number() | nil,
          marker_width: number(),
          orient: String.t() | number(),
          preserve_aspect_ratio: String.t() | nil,
          ref_x: number() | String.t(),
          ref_y: number() | String.t(),
          view_box: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @doc """
  Create a new marker definition.
  """
  @spec new() :: t()
  def new() do
    %__MODULE__{}
  end

  @doc """
  Set the size of the marker viewport.
  """
  @spec size(t(), number(), number()) :: t()
  def size(marker, width, height) do
    %{marker | marker_width: width, marker_height: height}
  end

  @doc """
  Set the reference point (anchor point) of the marker.
  """
  @spec ref(t(), number() | String.t(), number() | String.t()) :: t()
  def ref(marker, x, y) do
    %{marker | ref_x: x, ref_y: y}
  end

  @doc """
  Set the orientation of the marker. 

  Use `"auto"` to align with the slope of the parent line.
  """
  @spec orient(t(), String.t() | number()) :: t()
  def orient(marker, orient) do
    %{marker | orient: orient}
  end

  @doc """
  Set the graphic shape to be used as the marker.
  """
  @spec with_shape(t(), Vectored.Renderable.t() | list(Vectored.Renderable.t())) :: t()
  def with_shape(marker, shape) do
    %{marker | children: List.wrap(shape)}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Marker{children: children} = element) do
      attrs = Vectored.Elements.Marker.attributes(element)

      child_elems =
        Enum.map(children, &Vectored.Renderable.to_svg/1) ++
          Vectored.Elements.Element.render_common_children(element)

      {:marker, attrs, child_elems}
    end
  end
end
