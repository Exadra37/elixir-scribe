defmodule ElixirScribe.MixAPITest do
  alias ElixirScribe.MixAPI
  use ElixirScribe.BaseCase, async: true

  # @INFO: Tests in the API module only care about testing the function can be invoked and that the API contract is respected (for now only guards and pattern matching). The unit tests for the functionality are done in their respective modules

  describe "parse_cli_command/1" do
    test "can be invoked" do
      assert {_parsed_args, _opts, _invalid_args} = MixAPI.parse_cli_command([])
    end

    test "raises a FunctionClauseError when the argument isn't a list" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        MixAPI.parse_cli_command(%{})
      end
    end
  end
end
