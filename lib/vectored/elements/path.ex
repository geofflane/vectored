defmodule Vectored.Elements.Path do
  @moduledoc """
  d
  This attribute defines the shape of the path. Value type: <string> ; Default value: ''; Animatable: yes

  path_length
  This attribute lets authors specify the total length for the path, in user units. Value type: <number> ; Default value: none; Animatable: yes
  """
  use Vectored.Elements.Element, attributes: [d: "", path_length: nil]

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Path{} = element) do
      attrs = Vectored.Elements.Path.attributes(element)
      {:path, attrs, []}
    end
  end
end
