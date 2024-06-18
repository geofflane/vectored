defmodule Vectored.Elements.Svg do
  @moduledoc """
  height
  The displayed height of the rectangular viewport. (Not the height of its coordinate system.) Value type: <length>|<percentage> ; Default value: auto; Animatable: yes

  preserveAspectRatio
  How the svg fragment must be deformed if it is displayed with a different aspect ratio. Value type: (none| xMinYMin| xMidYMin| xMaxYMin| xMinYMid| xMidYMid| xMaxYMid| xMinYMax| xMidYMax| xMaxYMax) (meet|slice)? ; Default value: xMidYMid meet; Animatable: yes

  viewBox
  The SVG viewport coordinates for the current SVG fragment. Value type: <list-of-numbers> ; Default value: none; Animatable: yes

  width
  The displayed width of the rectangular viewport. (Not the width of its coordinate system.) Value type: <length>|<percentage> ; Default value: auto; Animatable: yes

  x
  The displayed x coordinate of the svg container. No effect on outermost svg elements. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes

  y
  The displayed y coordinate of the svg container. No effect on outermost svg elements. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes
  """
  use Vectored.Elements.Element, 
    attributes: [height: nil, width: nil, preserve_aspect_ratio: nil, view_box: nil, x: nil, y: nil, children: []]

  def new() do
    %__MODULE__{}
  end

  def new(width, height, children \\ []) do
    %__MODULE__{width: width, height: height, children: children}
  end

  def at_location(rectangle, x, y) do
    %{rectangle | x: x, y: y}
  end

  def with_size(rectangle, width, height) do
    %{rectangle | width: width, height: height}
  end

  @doc """
  Append one or more children to the svg document
  """
  def append(%__MODULE__{} = svg, children) when is_list(children) do
    Enum.reduce(children, svg, fn child, svg -> append(svg, child) end)
  end
  def append(%__MODULE__{children: children} = svg, child) do
    %{svg | children: children ++ [child]}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Svg{children: children} = element) do
      attrs = Vectored.Elements.Svg.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      {:svg, attrs, child_elems}
    end
  end
end
