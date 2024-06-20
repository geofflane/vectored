defmodule Vectored.Elements.Use do
  @moduledoc """
  Pull a definition from `defs` and render it at the given location.

  ## Details

  href
  The URL to an element/fragment that needs to be duplicated. See Usage notes for details on common pitfalls.
  Value type: <URL> ; Default value: none; Animatable: yes

  x
  The x coordinate of an additional final offset transformation applied to the <use> element.
  Value type: <coordinate> ; Default value: 0; Animatable: yes

  y
  The y coordinate of an additional final offset transformation applied to the <use> element.
  Value type: <coordinate> ; Default value: 0; Animatable: yes

  width
  The width of the use element.
  Value type: <length> ; Default value: 0; Animatable: yes

  height
  The height of the use element.
  Value type: <length> ; Default value: 0; Animatable: yes
  """

  use Vectored.Elements.Element,
    attributes: [href: nil, x: 0, y: 0, width: nil, height: nil]

  @type t :: %__MODULE__{
    href: String.t(),
    x: String.t() | number() | nil,
    y: String.t() | number() | nil,
    width: String.t() | number() | nil,
    height: String.t() | number() | nil,
  }

  @spec new(String.t()) :: t()
  def new(href) do
    %__MODULE__{href: href}
  end

  @spec new(String.t(), String.t() | number(), String.t() | number()) :: t()
  def new(href, x, y) do
    %__MODULE__{href: href, x: x, y: y}
  end

  @doc """
  Set the x and y properties of the Use to set its location
  """
  @spec at_location(t(), String.t() | number(),  String.t() | number()) :: t()
  def at_location(use, x, y) do
    %{use | x: x, y: y}
  end

  def with_size(use, width, height) do
    %{use | width: width, height: height}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Use{} = element) do
      attrs = Vectored.Elements.Use.attributes(element)
      {:use, attrs, []}
    end
  end
end
