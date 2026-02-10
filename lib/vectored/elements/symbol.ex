defmodule Vectored.Elements.Symbol do
  @moduledoc """
  The <symbol> SVG element is used to define graphical template objects which can be instantiated by a <use> element.
  """

  use Vectored.Elements.Element,
    attributes: [
      view_box: nil,
      preserve_aspect_ratio: nil,
      children: []
    ]

  @type t :: %__MODULE__{
          view_box: String.t() | nil,
          preserve_aspect_ratio: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @doc """
  Create a new symbol with children
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Append a child element
  """
  def append(%__MODULE__{children: children} = symbol, child) do
    %{symbol | children: children ++ List.wrap(child)}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Symbol{children: children} = element) do
      attrs = Vectored.Elements.Symbol.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      common_children = Vectored.Elements.Element.render_common_children(element)
      {:symbol, attrs, child_elems ++ common_children}
    end
  end
end
