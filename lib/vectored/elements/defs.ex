defmodule Vectored.Elements.Defs do
  @moduledoc """
  The `<defs>` element is a storage container for graphical objects that are 
  not intended to be rendered directly.

  ## Why use Defs?
  Think of `<defs>` as the "library" or "palette" of your SVG. You put things
  here that you want to reference later by ID:

    * **Gradients and Patterns**: Define the color math once, then apply it
      to shapes using `fill="url(#my-grad)"`.
    * **Icons and Symbols**: Define a complex shape that will be stamped
      across the drawing using `<use>`.
    * **Clipping Paths and Masks**: Define a shape that will "cookie cut" or
      transparently mask another element.

  Elements inside `<defs>` have no physical presence on the drawing until they
  are referenced.

  ## Examples

      Vectored.Elements.Defs.new([
        Vectored.Elements.LinearGradient.new() |> Vectored.Elements.LinearGradient.with_id("gold")
      ])

  """

  defstruct children: []

  @type children() :: list(Vectored.Renderable.t())
  @type t :: %__MODULE__{
          children: children()
        }

  @doc """
  Create a new `<defs>` container with an optional list of children.
  """
  @spec new(children()) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Append one or more children to the `<defs>` element.

  Accepts a single element, a list of elements, or a function that returns elements.
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
    def to_svg(%Vectored.Elements.Defs{children: children}) do
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      {:defs, [], child_elems}
    end
  end
end
