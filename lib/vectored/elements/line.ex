defmodule Vectored.Elements.Line do
  @moduledoc """
  The `<line>` element is an SVG basic shape used to draw a straight line between two points.

  ## Attributes

    * `x1`, `y1` - The coordinates of the start of the line.
    * `x2`, `y2` - The coordinates of the end of the line.
    * `stroke` - Lines are only visible if they have a `stroke` color.
    * `stroke_width` - The thickness of the line.

  ## Examples

      iex> Vectored.Elements.Line.new()
      ...> |> Vectored.Elements.Line.from(0, 0)
      ...> |> Vectored.Elements.Line.to(100, 100)
      ...> |> Vectored.Elements.Line.with_stroke("black")

  """

  use Vectored.Elements.Element,
    attributes: [x1: 0, x2: 0, y1: 0, y2: 0, path_length: nil]

  @type t :: %__MODULE__{
          x1: String.t() | number(),
          y1: String.t() | number(),
          x2: String.t() | number(),
          y2: String.t() | number(),
          path_length: number() | nil
        }

  @doc """
  Create a new line element. Points default to (0,0).
  """
  @spec new() :: t()
  def new() do
    %__MODULE__{}
  end

  @doc """
  Set the starting point of the line.
  """
  @spec from(t(), String.t() | number(), String.t() | number()) :: t()
  def from(line, x, y) do
    %{line | x1: x, y1: y}
  end

  @doc """
  Set the ending point of the line.
  """
  @spec to(t(), String.t() | number(), String.t() | number()) :: t()
  def to(line, x, y) do
    %{line | x2: x, y2: y}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Line{} = element) do
      attrs = Vectored.Elements.Line.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)
      {:line, attrs, children}
    end
  end
end
