defmodule Vectored.Elements.Group do
  @moduledoc """
  The `<g>` element is a container used to group other SVG elements.

  ## Why use a Group?
  Groups are essential for organizing your drawing and applying shared styles
  or transformations.

    * **Shared Styles**: Set `fill="red"` on a group, and all shapes inside
      will be red unless they specify their own color.
    * **Transforms**: Move or rotate an entire set of shapes at once by
      transforming their parent group.
    * **Organization**: Group related elements (like all parts of an icon)
      to make the SVG structure readable and easier to manipulate.

  ## Examples

      # Rotate a group of shapes around their shared center
      Vectored.Elements.Group.new([
        Vectored.Elements.Circle.new(10, 10, 5),
        Vectored.Elements.Circle.new(20, 20, 5)
      ])
      |> Vectored.Elements.Group.with_transform("rotate(45, 15, 15)")

  """

  use Vectored.Elements.Element,
    attributes: [children: []]

  @type children() :: list(Vectored.Renderable.t())
  @type t :: %__MODULE__{
          children: children()
        }

  @doc """
  Create a new group with an optional list of children.
  """
  @spec new(children()) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Append one or more children to the group.

  Accepts a single element, a list of elements, or a function that returns elements.

  ## Examples

      group |> Vectored.Elements.Group.append(Vectored.Elements.Circle.new(5))
      group |> Vectored.Elements.Group.append([rect1, rect2])
  """
  @spec append(
          t(),
          Vectored.Renderable.t() | children() | (-> Vectored.Renderable.t() | children())
        ) :: t()
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
