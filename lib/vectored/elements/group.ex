defmodule Vectored.Elements.Group do
  @moduledoc """
  The <g> SVG element is a container used to group other SVG elements.

  Transformations applied to the <g> element are performed on its child elements, and its attributes are inherited by its children.
  """

  use Vectored.Elements.Element,
    attributes: [children: []]

  @type children() :: list(Vectored.Renderable.t())
  @type t :: %__MODULE__{
          children: children()
        }

  @spec new(children()) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Append one or more SVG children
  """
  def append(%__MODULE__{} = svg, children) when is_list(children) do
    Enum.reduce(children, svg, fn child, svg -> append(svg, child) end)
  end

  def append(%__MODULE__{} = svg, func) when is_function(func) do
    append(svg, func.())
  end

  def append(%__MODULE__{children: children} = svg, child) do
    %{svg | children: children ++ [child]}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Group{children: children} = element) do
      attrs = Vectored.Elements.Group.attributes(element)

      child_elems =
        Enum.map(children, &Vectored.Renderable.to_svg/1) ++
          Vectored.Elements.Element.render_common_children(element)

      {:g, attrs, child_elems}
    end
  end
end
