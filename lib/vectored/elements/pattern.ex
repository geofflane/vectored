defmodule Vectored.Elements.Pattern do
  @moduledoc """
  The <pattern> SVG element defines a graphics object which can be redrawn at repeated x and y-coordinate intervals.
  """

  use Vectored.Elements.Element,
    attributes: [
      x: nil,
      y: nil,
      width: nil,
      height: nil,
      pattern_units: nil,
      pattern_content_units: nil,
      pattern_transform: nil,
      view_box: nil,
      preserve_aspect_ratio: nil,
      href: nil,
      children: []
    ],
    attribute_overrides: [
      pattern_units: :patternUnits,
      pattern_content_units: :patternContentUnits,
      pattern_transform: :patternTransform
    ]

  @type t :: %__MODULE__{
          x: String.t() | number() | nil,
          y: String.t() | number() | nil,
          width: String.t() | number() | nil,
          height: String.t() | number() | nil,
          pattern_units: String.t() | nil,
          pattern_content_units: String.t() | nil,
          pattern_transform: String.t() | nil,
          view_box: String.t() | nil,
          preserve_aspect_ratio: String.t() | nil,
          href: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @doc """
  Create a new pattern with children
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Set size
  """
  def with_size(pattern, width, height) do
    %{pattern | width: width, height: height}
  end

  @doc """
  Append a child
  """
  def append(%__MODULE__{children: children} = pattern, child) do
    %{pattern | children: children ++ List.wrap(child)}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Pattern{children: children} = element) do
      attrs = Vectored.Elements.Pattern.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      common_children = Vectored.Elements.Element.render_common_children(element)
      {:pattern, attrs, child_elems ++ common_children}
    end
  end
end
