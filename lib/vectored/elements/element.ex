defmodule Vectored.Elements.Element do
  @moduledoc """
  Helps to build elements by including common elements
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
    stroke_width: nil  # 5
  ]

  defmacro defelement(attributes) do
    all_attributes = Keyword.merge(@common_attributes, attributes)
    quote do
      @type t :: %__ENV__.module{}

      defstruct unquote(all_attributes)
    end
  end

  defmacro __using__(opts) do
    attributes = Keyword.get(opts, :attributes, [])
    attribute_overrides = Keyword.merge(@default_overrides, Keyword.get(opts, :attribute_overrides, []))

    quote do
      import Vectored.Elements.Element

      defelement unquote(attributes)

      def attrs() do
        (__ENV__.module.__struct__() |> Map.keys()) -- [:__struct__, :content, :children]
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
