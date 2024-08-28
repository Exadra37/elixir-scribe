Code.require_file("test/mix_test_helper.exs")

defmodule ElixirScribe.TemplateFileAPISyncTest do
  alias ElixirScribe.TemplateFileAPI
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  # Tests in the API module only care about testing the function can be invoked and that the API contract is respected for guards, pattern matching and expected return types. The unit tests for the functionality are done in their respective modules.

  # Check the ASYNC tests at test/elixir_scribe/template/template_binding_api_test.exs
  describe "inject_content_before_module_end/2" do
    test "can be invoked with the correct arguments types (string, string) and returns the expected atom (:ok) for a successful operation", config do
      in_tmp(config.test, fn ->
        module_content = """
        defmodule API do
        end
        """
        File.write!("api.ex", module_content)

        content_to_inject = """
        def whatever, do: :whatever
        """

        assert :ok = TemplateFileAPI.inject_content_before_module_end(content_to_inject, "api.ex")
      end)
    end

    test "returns the tuple {:noop, reason} for an unsuccessful operation", config do
      in_tmp(config.test, fn ->
        module_content = """
        defmodule API do
          def whatever, do: :whatever
        end
        """
        File.write!("api.ex", module_content)

        content_to_inject = """
          def whatever, do: :whatever
        """

        assert {:noop, :content_to_inject_already_exists} = TemplateFileAPI.inject_content_before_module_end(content_to_inject, "api.ex")
      end)
    end
  end
end
