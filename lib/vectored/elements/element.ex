defmodule Vectored.Elements.Element do
  @moduledoc """
  Helps to build elements by including common elements.
  """

  @default_overrides [
    pathLength: :path_length,
    stroke_width: :"stroke-width",
    view_box: :viewBox,
    preserve_aspect_ratio: :preserveAspectRatio
  ]

  @common_attributes [
    id: nil,
    class: nil,
    style: nil,
    fill: nil,         # "white",
    stroke: nil,       # "black",
    stroke_width: nil,  # 5
    desc: nil,
    title: nil,
  ]

  @type attributes :: %{
    optional(:attributes) => Keyword.t(),
    optional(:attribute_overrides) => Keyword.t(),
  }

  @doc """
  Defome an element that includes the default SVG attributes common to all SVG
  elements.

  ### Example

  ```
  use Vectored.Elements.Element,
       attributes: [cx: 0, cy: 0, r: 0, path_length: nil]
  ```
  """
  defmacro defelement(attributes) do
    all_attributes = Keyword.merge(@common_attributes, attributes)

    quote do
      defstruct unquote(all_attributes)
    end
  end

  @spec render_common_children(any()) :: list()
  def render_common_children(element) do
    element
    |> Map.take([:title, :desc])
    |> Enum.map(fn
      {_k, nil} -> nil
      {_k, elem} -> Vectored.Renderable.to_svg(elem)
    end)
    |> Enum.reject(&is_nil/1)
  end

  @doc """
  Helper used to define an element.
  """
  defmacro __using__(opts) do
    attributes = Keyword.get(opts, :attributes, [])
    attribute_overrides = Keyword.merge(@default_overrides, Keyword.get(opts, :attribute_overrides, []))

    quote do
      import Vectored.Elements.Element

      defelement unquote(attributes)

      def attrs() do
        (__ENV__.module.__struct__() |> Map.keys()) -- [:__struct__, :content, :children, :desc, :title]
      end

      def attributes(element) do
        Vectored.Elements.Element.attributes(element, attrs())
      end

      def rendered_key(key) do
        Keyword.get(unquote(attribute_overrides), key, key)
      end

      def with_fill(elem, fill) do
        %{elem | fill: fill}
      end

      def with_id(elem, id) do
        %{elem | id: id}
      end

      def with_stroke(elem, stroke) do
        %{elem | stroke: stroke}
      end

      def with_stroke_width(elem, width) do
        %{elem | stroke_width: width}
      end

      def with_view_box(elem, width, height) do
        with_view_box(elem, 0, 0, width, height)
      end

      def with_view_box(elem, minx, miny, width, height) do
        %{elem | view_box: "#{minx} #{miny} #{width} #{height}"}
      end

      def with_style(elem, style) do
        %{elem | style: style}
      end

      def with_description(elem, content) do
        %{elem | desc: Vectored.Elements.Desc.new(content)}
      end

      def with_title(elem, content) do
        %{elem | title: Vectored.Elements.Title.new(content)}
      end
    end
  end

  def attributes(element, attrs) do
    attrs
    |> Enum.map(fn key ->
      v = Map.get(element, key)
      if v do
        # to_string because xmerl only deals with iolist, atom and integers
        {element.__struct__.rendered_key(key), maybe_cast(v)}
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  def maybe_cast(v) when is_float(v), do: to_string(v)
  def maybe_cast(v), do: v
end
