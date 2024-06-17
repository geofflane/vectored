defmodule Vectored.Elements.Defs do
  use Vectored.Elements.Element,
    attributes: [children: []]

  def new(children) do
    %__MODULE__{children: children}
  end

  @doc """
  Append one or more SVG children
  """
  def append(%__MODULE__{children: children} = svg, children) when is_list(children) do
    Enum.reduce(children, svg, fn child, svg -> append(svg, child) end)
  end
  def append(%__MODULE__{children: children} = svg, child) do
    %{svg | children: children ++ [child]}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Defs{children: children} = element) do
      attrs = Vectored.Elements.Defs.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      {:defs, attrs, child_elems}
    end
  end
end
