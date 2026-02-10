defmodule Vectored.Elements.Element do
  @moduledoc """
  Core macros and helpers for defining SVG elements.

  This module provides the foundation for all SVG elements in the library.
  It defines common attributes shared by almost all SVG elements and provides
  a macro system to easily create new element types with consistent setter functions.

  ## Common Presentation Attributes: How shapes are styled

  In SVG, shapes are just geometries. To make them visible and styled, you use
  presentation attributes. Most elements in this library include these:

    * **Fill (`fill`)**: The color of the *inside* of the shape. Defaults to black.
      Use `"none"` for transparent interiors.
    * **Stroke (`stroke`)**: The color of the *outline*. Shapes have no outline
      by default.
    * **Stroke Width (`stroke_width`)**: How thick the outline is.
    * **Opacity (`opacity`)**: How transparent the whole element is (0.0 to 1.0).
    * **Transform (`transform`)**: Used to move (`translate`), rotate, or scale
      the element relative to its original position.

  ## Helper Functions

  When a module uses `Vectored.Elements.Element`, it automatically gains several
  helper functions:

    * `with_ATTR/2` - For every attribute defined, a setter function is created.
      For example, `with_fill(element, "red")`.
    * `with_style/2` - Accepts a keyword list of CSS styles. Use this if you
      prefer CSS-style strings over individual attributes.
    * `put_dataset/3`, `delete_dataset/2`, `with_dataset/2` - For `data-*` attributes.
      Useful for passing metadata to JavaScript or CSS.
    * `with_description/2`, `with_title/2` - For metadata children that help
      with accessibility (ARIA).

  """

  @default_overrides [
    path_length: :pathLength,
    stroke_width: :"stroke-width",
    view_box: :viewBox,
    preserve_aspect_ratio: :preserveAspectRatio,
    alignment_baseline: :"alignment-baseline",
    baseline_shift: :"baseline-shift",
    clip_path: :"clip-path",
    clip_rule: :"clip-rule",
    color_interpolation: :"color-interpolation",
    color_interpolation_filters: :"color-interpolation-filters",
    dominant_baseline: :"dominant-baseline",
    fill_opacity: :"fill-opacity",
    fill_rule: :"fill-rule",
    flood_color: :"flood-color",
    flood_opacity: :"flood-opacity",
    font_family: :"font-family",
    font_size: :"font-size",
    font_size_adjust: :"font-size-adjust",
    font_stretch: :"font-stretch",
    font_style: :"font-style",
    font_variant: :"font-variant",
    font_weight: :"font-weight",
    glyph_orientation_horizontal: :"glyph-orientation-horizontal",
    glyph_orientation_vertical: :"glyph-orientation-vertical",
    image_rendering: :"image-rendering",
    letter_spacing: :"letter-spacing",
    lighting_color: :"lighting-color",
    marker_end: :"marker-end",
    marker_mid: :"marker-mid",
    marker_start: :"marker-start",
    mask_type: :"mask-type",
    paint_order: :"paint-order",
    pointer_events: :"pointer-events",
    shape_rendering: :"shape-rendering",
    stop_color: :"stop-color",
    stop_opacity: :"stop-opacity",
    stroke_dasharray: :"stroke-dasharray",
    stroke_dashoffset: :"stroke-dashoffset",
    stroke_linecap: :"stroke-linecap",
    stroke_linejoin: :"stroke-linejoin",
    stroke_miterlimit: :"stroke-miterlimit",
    stroke_opacity: :"stroke-opacity",
    stroke_width: :"stroke-width",
    text_anchor: :"text-anchor",
    text_decoration: :"text-decoration",
    text_overflow: :"text-overflow",
    text_rendering: :"text-rendering",
    transform_origin: :"transform-origin",
    unicode_bidi: :"unicode-bidi",
    vector_effect: :"vector-effect",
    white_space: :"white-space",
    word_spacing: :"word-spacing",
    writing_mode: :"writing-mode"
  ]

  @common_children [
    desc: nil,
    title: nil
  ]

  @common_attributes [
    alignment_baseline: nil,
    baseline_shift: nil,
    dataset: nil,
    class: nil,
    clip_path: nil,
    clip_rule: nil,
    color: nil,
    color_interpolation: nil,
    color_interpolation_filters: nil,
    cursor: nil,
    direction: nil,
    display: nil,
    dominant_baseline: nil,
    # "white",
    fill: nil,
    fill_opacity: nil,
    fill_rule: nil,
    filter: nil,
    flood_color: nil,
    flood_opacity: nil,
    font_family: nil,
    font_size: nil,
    font_size_adjust: nil,
    font_stretch: nil,
    font_style: nil,
    font_variant: nil,
    font_weight: nil,
    glyph_orientation_horizontal: nil,
    glyph_orientation_vertical: nil,
    height: nil,
    href: nil,
    id: nil,
    image_rendering: nil,
    letter_spacing: nil,
    lighting_color: nil,
    marker_end: nil,
    marker_mid: nil,
    marker_start: nil,
    mask: nil,
    mask_type: nil,
    opacity: nil,
    overflow: nil,
    paint_order: nil,
    pointer_events: nil,
    preserve_aspect_ratio: nil,
    shape_rendering: nil,
    stop_color: nil,
    stop_opacity: nil,
    stroke: nil,
    stroke_dasharray: nil,
    stroke_dashoffset: nil,
    stroke_linecap: nil,
    stroke_linejoin: nil,
    stroke_miterlimit: nil,
    stroke_opacity: nil,
    stroke_width: nil,
    style: nil,
    text_anchor: nil,
    text_decoration: nil,
    text_overflow: nil,
    text_rendering: nil,
    transform: nil,
    transform_origin: nil,
    unicode_bidi: nil,
    vector_effect: nil,
    view_box: nil,
    visibility: nil,
    white_space: nil,
    width: nil,
    word_spacing: nil,
    writing_mode: nil,
    x: nil,
    y: nil
  ]

  @type attributes :: %{
          optional(:attributes) => Keyword.t(),
          optional(:attribute_overrides) => Keyword.t()
        }

  @doc """
  Defines the struct for an SVG element, including common SVG attributes.

  This is used by the `__using__` macro to setup the element's structure.
  The `attributes` parameter should be a keyword list of element-specific attributes
  and their default values.

  ## Example

      defelement(cx: 0, cy: 0, r: 0)
  """
  defmacro defelement(attributes) do
    all_attributes = Keyword.merge(@common_attributes ++ @common_children, attributes)

    quote do
      defstruct unquote(all_attributes)
    end
  end

  @spec render_common_children(any()) :: list()
  def render_common_children(element) do
    element
    |> Map.take([:title, :desc])
    |> Enum.map(fn
      {_k, nil} -> nil
      {_k, elem} -> Vectored.Renderable.to_svg(elem)
    end)
    |> Enum.reject(&is_nil/1)
  end

  @doc """
  Makes the calling module an SVG element.

  ## Options

    * `:attributes` - A keyword list of element-specific attributes and their defaults.
    * `:attribute_overrides` - A keyword list mapping internal field names to SVG
      attribute names (e.g., `stroke_width: :"stroke-width"`).

  When used, it defines a struct and a set of `with_*` setter functions.
  """
  defmacro __using__(opts) do
    attributes = Keyword.get(opts, :attributes, [])

    attribute_overrides =
      Keyword.merge(@default_overrides, Keyword.get(opts, :attribute_overrides, []))

    # Construct setters for common attribute values
    common_functions =
      for {attr, _} <- @common_attributes ++ attributes, uniq: true do
        quote do
          @doc unquote("""
               Simple setter to put the value `#{Keyword.get(attribute_overrides, attr, attr)}` onto the element
               """)
          @spec unquote(:"with_#{attr}")(t(), term()) :: t()
          def unquote(:"with_#{attr}")(elem, value) do
            %{elem | unquote(attr) => value}
          end
        end
      end

    quote do
      import Vectored.Elements.Element

      defelement(unquote(attributes))

      def attrs() do
        (__ENV__.module.__struct__() |> Map.keys()) --
          [:__struct__, :content, :children, :desc, :title, :private, :dataset]
      end

      def attributes(element) do
        Vectored.Elements.Element.attributes(element, attrs())
      end

      def rendered_key(key) do
        Keyword.get(unquote(attribute_overrides), key, key)
      end

      def with_view_box(elem, width, height) do
        with_view_box(elem, 0, 0, width, height)
      end

      def with_view_box(elem, minx, miny, width, height) do
        %{elem | view_box: "#{minx} #{miny} #{width} #{height}"}
      end

      def with_description(elem, content) do
        %{elem | desc: Vectored.Elements.Desc.new(content)}
      end

      def with_title(elem, content) do
        %{elem | title: Vectored.Elements.Title.new(content)}
      end

      @doc """
      Set the styles using a Keyword list of styles
      """
      def with_style(elem, styles) when is_list(styles) do
        style_str =
          styles
          |> Enum.map(fn {k, v} ->
            "#{k}: #{v}"
          end)
          |> Enum.join("; ")

        %{elem | style: style_str}
      end

      @doc """
      Set a dataset attribute. Mimics the DOM Element.dataset API.
      The key will be converted from camelCase to kebab-case for the data-* attribute.
      """
      def put_dataset(elem, key, value) when is_atom(key) do
        put_dataset(elem, Atom.to_string(key), value)
      end

      def put_dataset(elem, key, value) when is_binary(key) do
        current_dataset = elem.dataset || %{}
        %{elem | dataset: Map.put(current_dataset, key, value)}
      end

      @doc """
      Remove a dataset attribute
      """
      def delete_dataset(elem, key) when is_atom(key) do
        delete_dataset(elem, Atom.to_string(key))
      end

      def delete_dataset(elem, key) when is_binary(key) do
        current_dataset = elem.dataset || %{}
        %{elem | dataset: Map.delete(current_dataset, key)}
      end

      @doc """
      Set the entire dataset map at once
      """
      def with_dataset(elem, dataset) when is_map(dataset) do
        %{elem | dataset: dataset}
      end

      unquote_splicing(common_functions)
    end
  end

  def attributes(element, attrs) do
    regular_attrs =
      attrs
      |> Enum.map(fn key ->
        v = Map.get(element, key)

        if v do
          # to_string because xmerl only deals with iolist, atom and integers
          {element.__struct__.rendered_key(key), maybe_cast(v)}
        end
      end)
      |> Enum.reject(&is_nil/1)

    # Add dataset attributes as data-* attributes
    dataset_attrs =
      case Map.get(element, :dataset) do
        nil ->
          []

        dataset when is_map(dataset) and map_size(dataset) == 0 ->
          []

        dataset when is_map(dataset) ->
          dataset
          |> Enum.map(fn {key, value} ->
            # Convert camelCase key to data-kebab-case attribute name
            attr_name = camel_to_data_attr(key)
            {String.to_atom(attr_name), maybe_cast(value)}
          end)
      end

    regular_attrs ++ dataset_attrs
  end

  @doc false
  def camel_to_data_attr(key) when is_atom(key) do
    camel_to_data_attr(Atom.to_string(key))
  end

  def camel_to_data_attr(key) when is_binary(key) do
    kebab_key =
      key
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map_join(fn
        {grapheme, 0} ->
          # First character - just lowercase it, don't add hyphen
          String.downcase(grapheme)

        {grapheme, _index} ->
          if grapheme =~ ~r/[A-Z0-9]/ do
            "-" <> String.downcase(grapheme)
          else
            grapheme
          end
      end)

    "data-" <> kebab_key
  end

  def maybe_cast(v) when is_float(v), do: to_string(v)
  def maybe_cast(v), do: v
end
