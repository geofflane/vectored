defmodule Vectored.Elements.ClipPath do
  @moduledoc """
  The <clipPath> SVG element defines a clipping path, to be used by the clip-path attribute.

  A clipping path restricts the region to which paint can be applied. Conceptually, parts of the drawing that lie outside of the region bounded by the clipping path are not drawn.
  """

  use Vectored.Elements.Element,
    attributes: [
      clip_path_units: nil,
      children: []
    ],
    attribute_overrides: [clip_path_units: :clipPathUnits]

  @type t :: %__MODULE__{
          clip_path_units: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @doc """
  Create a new clipPath with children
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Append a child element
  """
  def append(%__MODULE__{children: children} = clip_path, child) do
    %{clip_path | children: children ++ List.wrap(child)}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.ClipPath{children: children} = element) do
      attrs = Vectored.Elements.ClipPath.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      common_children = Vectored.Elements.Element.render_common_children(element)
      {:clipPath, attrs, child_elems ++ common_children}
    end
  end
end
