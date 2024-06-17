defmodule Vectored.Elements.Element do
  @moduledoc """
  Helps to build elements by including common elements
  """

  defp common_attributes() do
    [fill: "white", stroke: "black", stroke_width: 5]
  end

  defmacro defelement(attributes) do
    all_attributes = Keyword.merge(common_attributes(), attributes)
    quote do
      defstruct unquote(all_attributes)
    end
  end

  defmacro __using__(attributes) do
    quote do
      import Vectored.Elements.Element

      defelement unquote(attributes)

      def attrs() do
        (__ENV__.module.__struct__() |> Map.keys()) -- [:__struct__, :content, :children]
      end

      def attributes(element) do
        Vectored.Elements.Element.attributes(element, attrs())
      end

      def rendered_key(:stroke_width), do: :"stroke-width"
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
