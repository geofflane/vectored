defmodule Vectored.Elements.Symbol do
  @moduledoc """
  The `<symbol>` element defines a graphical template that can be instantiated
  multiple times using the `<use>` element.

  ## Why use Symbol?
  While `<g>` (Group) also groups elements, `<symbol>` is different in two 
  important ways:

    * **Hidden by Default**: Unlike a group, a symbol is never rendered directly.
      It only appears when referenced by a `<use>` element.
    * **Independent Viewport**: A symbol can have its own `view_box`. This
      means you can define an icon in a 0-100 coordinate system and scale it 
      to fit any `width` and `height` in the `<use>` element.

  Symbols are the standard way to create **Icon Systems** in SVG.

  ## Examples

      # Define a 100x100 icon
      icon = Vectored.Elements.Symbol.new([shape1, shape2])
      |> Vectored.Elements.Symbol.with_view_box(0, 0, 100, 100)
      |> Vectored.Elements.Symbol.with_id("my-icon")

      # Stamp it at different sizes
      Vectored.Elements.Use.new("#my-icon") |> Vectored.Elements.Use.with_size(16, 16)
      Vectored.Elements.Use.new("#my-icon") |> Vectored.Elements.Use.with_size(64, 64)

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
  Create a new symbol with an optional list of children.
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Append a child element to the symbol.
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
