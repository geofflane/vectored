defmodule Vectored.Elements.LinearGradient do
  @moduledoc """
  The `<linearGradient>` element defines a linear transition between colors.

  It is typically placed inside a `<defs>` element and referenced by its `id`.

  ## Attributes

    * `x1`, `y1`, `x2`, `y2` - The start and end points of the gradient vector.
    * `gradient_units` - Defines the coordinate system (`"userSpaceOnUse"` or `"objectBoundingBox"`).
    * `spread_method` - How the gradient repeats (`"pad"`, `"reflect"`, `"repeat"`).

  ## Examples

      iex> Vectored.Elements.LinearGradient.new([
      ...>   Vectored.Elements.Stop.new(0, "red"),
      ...>   Vectored.Elements.Stop.new(1, "blue")
      ...> ])
      ...> |> Vectored.Elements.LinearGradient.with_id("my-grad")

  """

  use Vectored.Elements.Element,
    attributes: [
      x1: nil,
      y1: nil,
      x2: nil,
      y2: nil,
      gradient_units: nil,
      gradient_transform: nil,
      spread_method: nil,
      href: nil,
      children: []
    ],
    attribute_overrides: [
      gradient_units: :gradientUnits,
      gradient_transform: :gradientTransform,
      spread_method: :spreadMethod
    ]

  @type t :: %__MODULE__{
          x1: String.t() | number() | nil,
          y1: String.t() | number() | nil,
          x2: String.t() | number() | nil,
          y2: String.t() | number() | nil,
          gradient_units: String.t() | nil,
          gradient_transform: String.t() | nil,
          spread_method: String.t() | nil,
          href: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @doc """
  Create a new linear gradient with an optional list of `<stop>` children.
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Set the start and end coordinates of the gradient vector.
  """
  @spec with_coordinates(
          t(),
          String.t() | number(),
          String.t() | number(),
          String.t() | number(),
          String.t() | number()
        ) :: t()
  def with_coordinates(gradient, x1, y1, x2, y2) do
    %{gradient | x1: x1, y1: y1, x2: x2, y2: y2}
  end

  @doc """
  Append one or more children (typically `<stop>` elements) to the gradient.
  """
  @spec append(t(), Vectored.Renderable.t() | list(Vectored.Renderable.t())) :: t()
  def append(%__MODULE__{children: children} = gradient, stop) do
    %{gradient | children: children ++ List.wrap(stop)}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.LinearGradient{children: children} = element) do
      attrs = Vectored.Elements.LinearGradient.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      common_children = Vectored.Elements.Element.render_common_children(element)
      {:linearGradient, attrs, child_elems ++ common_children}
    end
  end
end
