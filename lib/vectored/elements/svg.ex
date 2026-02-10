defmodule Vectored.Elements.Svg do
  @moduledoc """
  The `<svg>` element is a container that defines a new coordinate system and viewport.

  It is typically used as the outermost element of SVG documents, but can also be
  nested to create local coordinate systems.

  ## Viewport and ViewBox: Why they matter

  One of the most powerful features of SVG is the ability to separate the drawing
  coordinates from the display size.

    * **Viewport (`width` / `height`)**: This defines how much space the SVG
      occupies in the browser or parent element. Think of this as the "frame"
      of the window.
    * **`view_box`**: This defines the internal "world" of your drawing. By
      setting a `view_box`, you can define a stable coordinate system (e.g.,
      0 to 100) and your drawing will automatically scale to fit whatever
      `width` and `height` you later choose for the viewport.

  If you don't set a `view_box`, the coordinates you use in your shapes will
  be interpreted as "user units", which usually map 1-to-1 to pixels.

  ## Attributes

    * `x`, `y` - Position of the SVG container. Use these when nesting an SVG
      inside another to shift the entire sub-drawing.
    * `width`, `height` - Display size. Use these to control the physical size
      on the screen. Values can be numbers (pixels) or percentages.
    * `view_box` - The internal coordinate system. Essential for making your
      graphics responsive and independent of their display size.
    * `preserve_aspect_ratio` - Controls what happens when the `view_box` and
      viewport have different shapes (e.g., a square drawing in a wide frame).

  ## Examples

      # This creates a responsive circle that always stays centered, 
      # no matter what size the SVG is scaled to.
      Vectored.Elements.Svg.new("100%", "100%")
      |> Vectored.Elements.Svg.with_view_box(0, 0, 100, 100)
      |> Vectored.Elements.Svg.append(Vectored.Elements.Circle.new(50, 50, 40))

  """
  alias Vectored.Elements.Defs

  use Vectored.Elements.Element,
    attributes: [
      defs: nil,
      children: [],
      private: %{}
    ]

  @type children :: list(Vectored.Renderable.t())
  @type t :: %__MODULE__{
          x: String.t() | number() | nil,
          y: String.t() | number() | nil,
          width: String.t() | number() | nil,
          height: String.t() | number() | nil,
          view_box: String.t() | nil,
          preserve_aspect_ratio: String.t() | nil,
          children: children(),
          defs: Vectored.Elements.Defs.t() | nil,
          private: map()
        }

  @doc """
  Create a new SVG document container.
  """
  @spec new() :: t()
  def new() do
    %__MODULE__{}
  end

  @doc """
  Create a new SVG document with specified dimensions.

  ## Examples

      Vectored.Elements.Svg.new(100, 100)
      Vectored.Elements.Svg.new("100%", "100%", [circle])
  """
  @spec new(String.t() | number(), String.t() | number(), children()) :: t()
  @spec new(String.t() | number(), String.t() | number()) :: t()
  def new(width, height, children \\ []) do
    %__MODULE__{width: width, height: height, children: children}
  end

  @doc """
  Set the x and y coordinates of the SVG container.

  Note: This generally only has an effect when the SVG is nested inside another SVG.
  """
  @spec at_location(t(), String.t() | number(), String.t() | number()) :: t()
  def at_location(rectangle, x, y) do
    %{rectangle | x: x, y: y}
  end

  @doc """
  Set the width and height of the SVG viewport.
  """
  def with_size(rectangle, width, height) do
    %{rectangle | width: width, height: height}
  end

  @doc """
  Append children to the SVG element.

  Accepts a single element, a list of elements, or a function that returns elements.
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

  @doc """
  Append elements to the `<defs>` section of the SVG.

  If no `<defs>` element exists, one will be created.
  """
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

  @doc """
  Store private metadata in the SVG struct. This data is not rendered to SVG.
  """
  def put_private(%__MODULE__{} = svg, key, value) do
    %{svg | private: Map.put(svg.private, key, value)}
  end

  @doc """
  Remove private metadata.
  """
  def delete_private(%__MODULE__{} = svg, key) do
    %{svg | private: Map.delete(svg.private, key)}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Svg{children: children, defs: defs} = element) do
      attrs = Vectored.Elements.Svg.attributes(element) |> Keyword.drop([:defs])
      common_children = Vectored.Elements.Element.render_common_children(element)

      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      def_elem = if defs, do: [Vectored.Renderable.to_svg(defs)], else: []

      children = common_children ++ def_elem ++ child_elems
      {:svg, attrs, children}
    end
  end
end
