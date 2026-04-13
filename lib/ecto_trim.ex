defmodule EctoTrim do
  @moduledoc """
  Ecto parameterized type that trims and normalizes whitespace on cast and dump.

  ## Options

  - `:mode` — `:single_line` (default) or `:multi_line`
    - `:single_line` — collapses all whitespace to single spaces
    - `:multi_line` — preserves newlines but collapses 3+ consecutive newlines to 2

  ## Usage

      schema "companies" do
        field :name, EctoTrim
        field :bio, EctoTrim, mode: :multi_line
      end
  """

  use Ecto.ParameterizedType

  @type mode :: :single_line | :multi_line
  @type params :: %{mode: mode()}

  @impl true
  @spec type(params()) :: :string
  def type(_params), do: :string

  @impl true
  @spec init(keyword()) :: params()
  def init(opts) do
    mode = Keyword.get(opts, :mode, :single_line)

    unless mode in [:single_line, :multi_line] do
      raise ArgumentError, "EctoTrim :mode must be :single_line or :multi_line, got: #{inspect(mode)}"
    end

    %{mode: mode}
  end

  @impl true
  @spec cast(term(), params()) :: {:ok, String.t() | nil} | :error
  def cast(nil, _params), do: {:ok, nil}

  def cast(str, %{mode: mode}) when is_binary(str) do
    {:ok, str |> String.trim() |> normalize(mode)}
  end

  def cast(_, _params), do: :error

  @impl true
  @spec dump(term(), function(), params()) :: {:ok, String.t() | nil} | :error
  def dump(nil, _dumper, _params), do: {:ok, nil}

  def dump(str, _dumper, %{mode: mode}) when is_binary(str) do
    {:ok, str |> String.trim() |> normalize(mode)}
  end

  @impl true
  @spec load(term(), function(), params()) :: {:ok, String.t() | nil}
  def load(nil, _loader, _params), do: {:ok, nil}

  def load(str, _loader, _params) when is_binary(str), do: {:ok, str}

  @spec normalize(String.t(), mode()) :: String.t()
  defp normalize(str, :single_line), do: String.replace(str, ~r/\s+/, " ")
  defp normalize(str, :multi_line), do: String.replace(str, ~r/\n{3,}/, "\n\n")
end
