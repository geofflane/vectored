defmodule Vectored.Elements.Group do
  use Vectored.Elements.Element,
    attributes: [children: []]

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Group{children: children} = element) do
      attrs = Vectored.Elements.Group.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      {:g, attrs, child_elems}
    end
  end
end
