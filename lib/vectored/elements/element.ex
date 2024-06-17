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
    fill: nil,         # "white",
    stroke: nil,       # "black",
    stroke_width: nil  # 5
  ]

  defmacro defelement(attributes) do
    all_attributes = Keyword.merge(@common_attributes, attributes)
    quote do
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
    end
  end

  def attributes(element, attrs) do
    attrs
    |> Enum.map(fn key ->
      v = Map.get(element, key)
      if v do
        {element.__struct__.rendered_key(key), v}
      end
    end)
    |> Enum.reject(&is_nil/1)
  end
end
