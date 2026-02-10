defmodule Vectored.Elements.ClipPath do
  @moduledoc """
  The `<clipPath>` element defines a shape that is used to "cut out" parts of 
  other elements.

  ## Why use ClipPath?
  Clipping is like using a **cookie cutter**. Anything outside the clipping 
  shape is simply not drawn.

    * **Shape Masks**: Make an image appear inside a circle or a complex star 
      shape.
    * **Hard Edges**: Unlike `<mask`, a clipping path is binary—an area is 
      either fully visible or fully hidden.
    * **Efficiency**: Clipping is generally faster for browsers to render 
      than transparency-based masking.

  ## Examples

      # Define a circular cookie cutter
      clip = Vectored.Elements.ClipPath.new([
        Vectored.Elements.Circle.new(50, 50, 40)
      ]) |> Vectored.Elements.ClipPath.with_id("my-clip")

      # Apply it to a large rectangle
      Vectored.Elements.Rectangle.new(0, 0, 100, 100)
      |> Vectored.Elements.Rectangle.with_clip_path("url(#my-clip)")

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
  Create a new clipping path with an optional list of children.
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Append a child shape to the clipping path.
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
