defmodule ElixirScribe.TemplateBindingAPITest do
  alias ElixirScribe.TemplateBindingAPI
  use ElixirScribe.BaseCase, async: true

  # @INFO: Tests in the API module only care about testing the function can be invoked and that the API contract is respected (for now only guards and pattern matching). The unit tests for the functionality are done in their respective modules

  describe "build_binding_template/1" do
    test "returns a list" do
      contract = domain_contract_fixture()

      assert TemplateBindingAPI.build_binding_template(contract) |> is_list()
    end
  end

  describe "rebuild_binding_template/1" do
    test "returns a list" do
      contract = domain_contract_fixture()

      binding = TemplateBindingAPI.build_binding_template(contract)

      assert TemplateBindingAPI.rebuild_binding_template(binding, "whatever_action",
               file_type: :lib_core
             )
             |> is_list()
    end
  end
end
