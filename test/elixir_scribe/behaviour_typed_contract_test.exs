defmodule ElixirScribe.Behaviour.TypedContractTest do
  use ExUnit.Case, async: true
  doctest ElixirScribe.Behaviour.TypedContract

  # test "raises when creating a contract without providing the default value for an optional attribute " do

  #   defmodule CarContract do
  #     @moduledoc false

  #     @keys %{
  #       required: [:brand, :model],
  #       optional: [:year]
  #     }

  #     use ElixirScribe.Behaviour.TypedContract, keys: @keys

  #     @impl true
  #     def type_spec() do
  #       schema(%__MODULE__{
  #         brand: is_binary() |> spec(),
  #         model: is_binary() |> spec(),
  #         year: is_integer() |> spec() || nil,
  #       })
  #     end
  #   end

  #   dbg("me at")

  #   _expected_error = """
  #   ** (RuntimeError) Elixir.ElixirScribe.Behaviour.TypedContractTest.CarContract

  #       All optional fields in the Typed Contract MUST have a default value:

  #         * Incorrect: [:a, :b] or [:a, b: :default]

  #         * Correct: [a: :default, b: :default]

  #       Your fields:

  #       [:year]
  #   """

  #   assert_raise RuntimeError,  ~r/^All optional fields in the Typed Contract MUST have a default value:.*$/s, fn ->
  #     attrs = %{required: [name: "Toyota", model: "Supra"], optional: [year: 2]}
  #     # CarContract.new(attrs)
  #   end
  # end
end
