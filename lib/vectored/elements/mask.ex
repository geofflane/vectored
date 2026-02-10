defmodule Vectored.Elements.Mask do
  @moduledoc """
  The <mask> SVG element is used for defining an alpha mask for compositing the current object into the background.
  """

  use Vectored.Elements.Element,
    attributes: [
      x: nil,
      y: nil,
      width: nil,
      height: nil,
      mask_units: nil,
      mask_content_units: nil,
      children: []
    ],
    attribute_overrides: [
      mask_units: :maskUnits,
      mask_content_units: :maskContentUnits
    ]

  @type t :: %__MODULE__{
          x: String.t() | number() | nil,
          y: String.t() | number() | nil,
          width: String.t() | number() | nil,
          height: String.t() | number() | nil,
          mask_units: String.t() | nil,
          mask_content_units: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @doc """
  Create a new mask with children
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Append a child element
  """
  def append(%__MODULE__{children: children} = mask, child) do
    %{mask | children: children ++ List.wrap(child)}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Mask{children: children} = element) do
      attrs = Vectored.Elements.Mask.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      common_children = Vectored.Elements.Element.render_common_children(element)
      {:mask, attrs, child_elems ++ common_children}
    end
  end
end
