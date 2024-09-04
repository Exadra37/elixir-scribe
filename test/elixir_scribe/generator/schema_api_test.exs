defmodule ElixirScribe.Generator.SchemaAPITest do
  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.SchemaAPI
  alias ElixirScribe.Generator.SchemaContract
  use ElixirScribe.BaseCase, async: true

  # Tests in the API module only care about testing the function can be invoked and that the API contract is respected for guards, pattern matching and expected return types. The unit tests for the functionality are done in their respective modules.

  describe "build_schema_resource_contract/2" do
    test "can be invoked with the correct arguments types (list, list) and returns the expected tuple ({:ok, %SchemaContract{}})" do
      args = ["Blog", "Post", "posts", "title:string", "desc:string"]

      {valid_args, opts, _invalid_args} = args |> MixAPI.parse_cli_command()

      assert {:ok, %SchemaContract{} = contract} =
               SchemaAPI.build_schema_resource_contract(valid_args, opts)

      assert ^contract = SchemaAPI.build_schema_resource_contract!(valid_args, opts)
    end

    test "raises a FunctionClauseError when isn't invoked with the correct first argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        SchemaAPI.build_schema_resource_contract(%{}, [])
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct second argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        SchemaAPI.build_schema_resource_contract([], %{})
      end
    end
  end
end
