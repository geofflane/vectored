defmodule Vectored.Elements.DatasetTest do
  use ExUnit.Case, async: true

  alias Vectored.Elements.Circle
  alias Vectored.Elements.Element
  alias Vectored.Elements.Rectangle
  alias Vectored.Elements.Svg

  describe "dataset functionality" do
    test "elements have nil dataset by default" do
      circle = Circle.new(50)
      assert circle.dataset == nil
    end

    test "can add dataset values using put_dataset" do
      circle =
        Circle.new(50)
        |> Circle.put_dataset(:userId, "123")
        |> Circle.put_dataset(:userName, "John Doe")

      assert circle.dataset == %{userId: "123", userName: "John Doe"}
    end

    test "put_dataset rejects string keys" do
      assert_raise FunctionClauseError, fn ->
        # apply/3 keeps the deliberately invalid string key out of compile-time type checking.
        # credo:disable-for-next-line Credo.Check.Refactor.Apply
        apply(Circle, :put_dataset, [Circle.new(50), "userId", "123"])
      end
    end

    test "can remove dataset values using delete_dataset" do
      circle =
        Circle.new(50)
        |> Circle.put_dataset(:userId, "123")
        |> Circle.put_dataset(:userName, "Jane")
        |> Circle.delete_dataset(:userId)

      assert circle.dataset == %{userName: "Jane"}
    end

    test "delete_dataset rejects string keys" do
      assert_raise FunctionClauseError, fn ->
        # apply/3 keeps the deliberately invalid string key out of compile-time type checking.
        # credo:disable-for-next-line Credo.Check.Refactor.Apply
        apply(Circle, :delete_dataset, [Circle.new(50), "userId"])
      end
    end

    test "can set entire dataset at once with with_dataset" do
      circle =
        Circle.new(50)
        |> Circle.with_dataset(%{productId: "789", categoryName: "electronics"})

      assert circle.dataset == %{productId: "789", categoryName: "electronics"}
    end

    test "with_dataset rejects string keys with a helpful message" do
      error =
        assert_raise ArgumentError, fn ->
          Circle.with_dataset(Circle.new(50), %{"productId" => "789"})
        end

      assert error.message =~ "dataset keys must be atoms"
      assert error.message =~ ~s("productId")
    end

    test "with_dataset rejects mixed keys and lists every bad key" do
      error =
        assert_raise ArgumentError, fn ->
          Circle.with_dataset(Circle.new(50), %{:ok => 1, "badOne" => 2, "badTwo" => 3})
        end

      assert error.message =~ ~s("badOne")
      assert error.message =~ ~s("badTwo")
      refute error.message =~ ":ok"
    end

    test "delete_dataset on an element with no dataset is a no-op" do
      circle = Circle.delete_dataset(Circle.new(50), :userId)

      assert circle.dataset == %{}
      assert {:ok, ~s|<circle cx="0" cy="0" r="50"/>|} = Vectored.to_svg_string(circle)
    end

    test "rendering rejects string keys set directly on the struct" do
      circle = %{Circle.new(50) | dataset: %{"userId" => "1"}}

      assert_raise ArgumentError, ~r/dataset keys must be atoms/, fn ->
        Vectored.to_svg_string(circle)
      end
    end

    test "dataset attributes are rendered as data-* attributes" do
      circle =
        Circle.new(50)
        |> Circle.put_dataset(:userId, "123")
        |> Circle.put_dataset(:userName, "John Doe")

      {:ok, svg_output} = Vectored.to_svg_string(circle)

      assert svg_output =~ ~r/data-user-id="123"/
      assert svg_output =~ ~r/data-user-name="John Doe"/
    end

    test "regular attributes come first, sorted, then data-* attributes, sorted" do
      {:circle, attrs, []} =
        Circle.new(50)
        |> Circle.put_dataset(:zeta, "z")
        |> Circle.with_stroke("blue")
        |> Circle.put_dataset(:alpha, "a")
        |> Circle.with_fill("red")
        |> Circle.put_dataset(:middleKey, "m")
        |> Vectored.Renderable.to_svg()

      assert attrs == [
               cx: 0,
               cy: 0,
               fill: "red",
               r: 50,
               stroke: "blue",
               "data-alpha": "a",
               "data-middle-key": "m",
               "data-zeta": "z"
             ]
    end

    test "camelCase keys are converted to kebab-case attributes" do
      rect =
        Rectangle.new(0, 0, 100, 50)
        |> Rectangle.put_dataset(:mySpecialValue, "test")
        |> Rectangle.put_dataset(:anotherCamelCaseKey, "value")

      {:ok, svg_output} = Vectored.to_svg_string(rect)

      assert svg_output =~ ~r/data-my-special-value="test"/
      assert svg_output =~ ~r/data-another-camel-case-key="value"/
    end

    test "dataset with various value types" do
      circle =
        Circle.new(50)
        |> Circle.put_dataset(:count, 42)
        |> Circle.put_dataset(:price, 19.99)
        |> Circle.put_dataset(:active, true)
        |> Circle.put_dataset(:hidden, false)

      {:ok, svg_output} = Vectored.to_svg_string(circle)

      assert svg_output =~ ~r/data-count="42"/
      assert svg_output =~ ~r/data-price="19\.99"/
      assert svg_output =~ ~r/data-active="true"/
      assert svg_output =~ ~r/data-hidden="false"/
    end

    test "dataset works with SVG container" do
      svg =
        Svg.new(200, 200)
        |> Svg.put_dataset(:appVersion, "1.0.0")
        |> Svg.put_dataset(:theme, "dark")

      {:ok, svg_output} = Vectored.to_svg_string(svg)

      assert svg_output =~ ~r/data-app-version="1\.0\.0"/
      assert svg_output =~ ~r/data-theme="dark"/
    end

    test "dataset doesn't interfere with regular attributes" do
      circle =
        Circle.new(50)
        |> Circle.at_location(100, 100)
        |> Circle.with_fill("red")
        |> Circle.with_stroke("blue")
        |> Circle.put_dataset(:elementId, "circle1")

      {:ok, svg_output} = Vectored.to_svg_string(circle)

      assert svg_output =~ ~r/cx="100"/
      assert svg_output =~ ~r/cy="100"/
      assert svg_output =~ ~r/r="50"/
      assert svg_output =~ ~r/fill="red"/
      assert svg_output =~ ~r/stroke="blue"/
      assert svg_output =~ ~r/data-element-id="circle1"/
    end

    test "empty dataset doesn't add any attributes" do
      circle =
        Circle.new(50)
        |> Circle.with_dataset(%{})

      {:ok, svg_output} = Vectored.to_svg_string(circle)

      refute svg_output =~ ~r/data-/
    end

    test "can update existing dataset values" do
      circle =
        Circle.new(50)
        |> Circle.put_dataset(:status, "pending")
        |> Circle.put_dataset(:status, "completed")

      assert circle.dataset == %{status: "completed"}

      {:ok, svg_output} = Vectored.to_svg_string(circle)
      assert svg_output =~ ~r/data-status="completed"/
      refute svg_output =~ ~r/data-status="pending"/
    end
  end

  describe "camel_to_data_attr conversion" do
    test "converts simple camelCase" do
      assert Element.camel_to_data_attr(:userId) == "data-user-id"
      assert Element.camel_to_data_attr(:userName) == "data-user-name"
    end

    test "handles multiple capital letters" do
      assert Element.camel_to_data_attr(:XMLHttpRequest) == "data-x-m-l-http-request"
      assert Element.camel_to_data_attr(:myAPIKey) == "data-my-a-p-i-key"
    end

    test "handles digits" do
      assert Element.camel_to_data_attr(:item2) == "data-item-2"
      assert Element.camel_to_data_attr(:row10Col3) == "data-row-1-0-col-3"
    end

    test "handles lowercase keys" do
      assert Element.camel_to_data_attr(:simple) == "data-simple"
      assert Element.camel_to_data_attr(:alllowercase) == "data-alllowercase"
    end

    test "handles keys starting with capital" do
      assert Element.camel_to_data_attr(:UserId) == "data-user-id"
      assert Element.camel_to_data_attr(:Name) == "data-name"
    end
  end
end
