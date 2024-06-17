defmodule Vectored.Elements.Path do
  @moduledoc """
  d
  This attribute defines the shape of the path. Value type: <string> ; Default value: ''; Animatable: yes

  path_length
  This attribute lets authors specify the total length for the path, in user units. Value type: <number> ; Default value: none; Animatable: yes
  """
  use Vectored.Elements.Element, d: "", path_length: nil

  def rendered_key(:path_length), do: :pathLength
  def rendered_key(k), do: k

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Path{} = element) do
      attrs = Vectored.Elements.Path.attributes(element)
      {:path, attrs, []}
    end
  end
end
