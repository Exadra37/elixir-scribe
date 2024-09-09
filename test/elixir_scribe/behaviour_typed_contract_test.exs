defmodule ElixirScribe.Behaviour.TypedContractTest do
  use ExUnit.Case, async: true
  doctest ElixirScribe.Behaviour.TypedContract

  defmodule CarContract do
    @moduledoc false

    @keys %{
      required: [:brand, :model],
      optional: [year: nil]
    }

    use ElixirScribe.Behaviour.TypedContract, keys: @keys

    @impl true
    def type_spec() do
      schema(%__MODULE__{
        brand: is_binary() |> spec(),
        model: is_binary() |> spec(),
        year: spec(is_integer() or is_nil())
      })
    end
  end

  test "it can create a typed contract with :required and :optional keys" do
    attrs = %{
      brand: "Toyota",
      model: "Supra",
      year: 2000
    }

    assert {:ok, %CarContract{} = contract} = CarContract.new(attrs)
    assert ^contract = CarContract.new!(attrs)
  end

  defmodule ProductContract do
    @moduledoc false

    @keys %{
      required: [:title, :description]
    }

    use ElixirScribe.Behaviour.TypedContract, keys: @keys

    @impl true
    def type_spec() do
      schema(%__MODULE__{
        title: is_binary() |> spec(),
        description: is_binary() |> spec()
      })
    end
  end

  test "it can create a typed contract without the :optional key" do
    attrs = %{
      title: "Penguin Laptop",
      description: "Awesome Linux machine"
    }

    assert {:ok, %ProductContract{} = contract} = ProductContract.new(attrs)
    assert ^contract = ProductContract.new!(attrs)
  end
end
