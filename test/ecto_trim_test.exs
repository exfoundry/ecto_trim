defmodule EctoTrimTest do
  use ExUnit.Case, async: true

  describe "init/1" do
    test "defaults to single_line" do
      assert %{mode: :single_line} = EctoTrim.init([])
    end

    test "accepts :single_line" do
      assert %{mode: :single_line} = EctoTrim.init(mode: :single_line)
    end

    test "accepts :multi_line" do
      assert %{mode: :multi_line} = EctoTrim.init(mode: :multi_line)
    end

    test "rejects invalid mode" do
      assert_raise ArgumentError, fn -> EctoTrim.init(mode: :invalid) end
    end
  end

  describe "cast/2 single_line" do
    setup do
      %{params: EctoTrim.init(mode: :single_line)}
    end

    test "trims leading and trailing whitespace", %{params: params} do
      assert {:ok, "hello"} = EctoTrim.cast("  hello  ", params)
    end

    test "collapses internal whitespace to single space", %{params: params} do
      assert {:ok, "Person 1"} = EctoTrim.cast("  Person    1   ", params)
    end

    test "collapses tabs and newlines to single space", %{params: params} do
      assert {:ok, "a b c"} = EctoTrim.cast("a\t\nb\n\nc", params)
    end

    test "passes through nil", %{params: params} do
      assert {:ok, nil} = EctoTrim.cast(nil, params)
    end

    test "rejects non-binary", %{params: params} do
      assert :error = EctoTrim.cast(123, params)
    end

    test "handles empty string", %{params: params} do
      assert {:ok, ""} = EctoTrim.cast("", params)
    end

    test "handles whitespace-only string", %{params: params} do
      assert {:ok, ""} = EctoTrim.cast("   ", params)
    end
  end

  describe "cast/2 multi_line" do
    setup do
      %{params: EctoTrim.init(mode: :multi_line)}
    end

    test "preserves single newlines", %{params: params} do
      assert {:ok, "a\nb"} = EctoTrim.cast("a\nb", params)
    end

    test "preserves double newlines", %{params: params} do
      assert {:ok, "a\n\nb"} = EctoTrim.cast("a\n\nb", params)
    end

    test "collapses 3+ newlines to double", %{params: params} do
      assert {:ok, "a\n\nb"} = EctoTrim.cast("a\n\n\nb", params)
      assert {:ok, "a\n\nb"} = EctoTrim.cast("a\n\n\n\n\nb", params)
    end

    test "trims leading and trailing whitespace", %{params: params} do
      assert {:ok, "hello"} = EctoTrim.cast("   hello   ", params)
    end

    test "does not collapse inline spaces", %{params: params} do
      assert {:ok, "hello   world"} = EctoTrim.cast("hello   world", params)
    end
  end

  describe "dump/3" do
    test "normalizes on dump" do
      params = EctoTrim.init(mode: :single_line)
      assert {:ok, "hello world"} = EctoTrim.dump("  hello   world  ", &Function.identity/1, params)
    end

    test "handles nil" do
      params = EctoTrim.init([])
      assert {:ok, nil} = EctoTrim.dump(nil, &Function.identity/1, params)
    end
  end

  describe "load/3" do
    test "passes through as-is" do
      params = EctoTrim.init([])
      assert {:ok, "  hello  "} = EctoTrim.load("  hello  ", &Function.identity/1, params)
    end

    test "handles nil" do
      params = EctoTrim.init([])
      assert {:ok, nil} = EctoTrim.load(nil, &Function.identity/1, params)
    end
  end
end
