defmodule Vectored.Elements.Marker do
  @moduledoc """
  markerHeight
  This attribute defines the height of the marker viewport. Value type: <length> ; Default value: 3; Animatable: yes

  markerUnits
  This attribute defines the coordinate system for the attributes markerWidth, markerHeight and the contents of the <marker>. Value type: userSpaceOnUse|strokeWidth ; Default value: strokeWidth; Animatable: yes

  markerWidth
  This attribute defines the width of the marker viewport. Value type: <length> ; Default value: 3; Animatable: yes

  orient
  This attribute defines the orientation of the marker relative to the shape it is attached to. Value type: auto|auto-start-reverse|<angle> ; Default value: 0; Animatable: yes

  preserveAspectRatio
  This attribute defines how the svg fragment must be deformed if it is embedded in a container with a different aspect ratio. Value type: (none| xMinYMin| xMidYMin| xMaxYMin| xMinYMid| xMidYMid| xMaxYMid| xMinYMax| xMidYMax| xMaxYMax) (meet|slice)? ; Default value: xMidYMid meet; Animatable: yes

  refX
  This attribute defines the x coordinate for the reference point of the marker. Value type: left|center|right|<coordinate> ; Default value: 0; Animatable: yes

  refY
  This attribute defines the y coordinate for the reference point of the marker. Value type: top|center|bottom|<coordinate> ; Default value: 0; Animatable: yes

  viewBox
  This attribute defines the bound of the SVG viewport for the current SVG fragment. Value type: <list-of-numbers> ; Default value: none; Animatable: yes
  """

  use Vectored.Elements.Element,
    attributes: [
      marker_height: 3,
      marker_units: nil,
      marker_width: 3,
      orient: 0,
      preserve_aspect_ration: nil,
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
          preserve_aspect_ration: String.t() | nil,
          ref_x: number() | String.t(),
          ref_y: number() | String.t(),
          view_box: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @spec new() :: t()
  def new() do
    %__MODULE__{}
  end

  def size(marker, width, height) do
    %{marker | marker_width: width, marker_height: height}
  end

  def ref(marker, x, y) do
    %{marker | ref_x: x, ref_y: y}
  end

  def orient(marker, orient) do
    %{marker | orient: orient}
  end

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
