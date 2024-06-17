defmodule Vectored.Elements.Group do
  use Vectored.Elements.Element, children: []

  def rendered_key(k), do: k

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Group{children: children} = element) do
      attrs = Vectored.Elements.Group.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      {:g, attrs, child_elems}
    end
  end
end
