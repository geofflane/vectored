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
  alias Vectored.Elements.Defs

  use Vectored.Elements.Element,
    attributes: [height: nil, width: nil, preserve_aspect_ratio: nil, view_box: nil, x: nil, y: nil, defs: nil, children: []]

  @type children :: list(Vectored.Renderable.t())
  @type t :: %__MODULE__{
    x: String.t() | number() | nil,
    y: String.t() | number() | nil,
    width: String.t() | number() | nil,
    height: String.t() | number() | nil,
    view_box: String.t() | nil,
    preserve_aspect_ratio: String.t() | nil,
    children: children(),
    defs: Vectored.Elements.Defs.t() | nil
  }

  @spec new() :: t()
  def new() do
    %__MODULE__{}
  end

  @spec new(String.t() | number(), String.t() | number(), children()) :: t()
  @spec new(String.t() | number(), String.t() | number()) :: t()
  def new(width, height, children \\ []) do
    %__MODULE__{width: width, height: height, children: children}
  end

  @doc """
  Set the x and y properties of the Svg to set its location
  """
  @spec at_location(t(), String.t() | number(),  String.t() | number()) :: t()
  def at_location(rectangle, x, y) do
    %{rectangle | x: x, y: y}
  end

  def with_size(rectangle, width, height) do
    %{rectangle | width: width, height: height}
  end

  @doc """
  Append one or more children to the svg document
  """
  def append(%__MODULE__{children: children} = svg, elements) when is_list(elements) do
    %{svg | children: children ++ elements}
  end
  def append(%__MODULE__{} = svg, func) when is_function(func) do
    append(svg, func.())
  end
  def append(%__MODULE__{} = svg, element) do
    append(svg, List.wrap(element))
  end

  def append_defs(%__MODULE__{defs: defs} = svg, elements) when is_list(elements) do
    new_defs =
      if defs do
        defs
        |> Defs.append(elements)
      else
        Defs.new(elements)
      end

    %{svg | defs: new_defs}
  end
  def append_defs(%__MODULE__{} = svg, element) do
    append_defs(svg, List.wrap(element))
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Svg{children: children, defs: defs} = element) do
      attrs = Vectored.Elements.Svg.attributes(element) |> Keyword.drop([:defs])
      common_children = Vectored.Elements.Element.render_common_children(element)

      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      def_elem = if defs, do: [Vectored.Renderable.to_svg(defs)], else: []

      children = common_children ++ def_elem ++ child_elems
      {:svg, attrs, def_elem ++ children}
    end
  end
end
