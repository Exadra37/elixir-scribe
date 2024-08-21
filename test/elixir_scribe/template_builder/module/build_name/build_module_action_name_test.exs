defmodule ElixirScribe.TemplateBuilder.Module.BuildName.BuildModuleActionNameTest do
  alias ElixirScribe.TemplateBuilderAPI
  use ElixirScribe.BaseCase, async: true

  test "it builds the module action name for a singular action" do
    contract = domain_contract_fixture()

    assert TemplateBuilderAPI.build_module_action_name(contract, "read") === "ReadPost"
  end

  test "it builds the module action name for a plural action" do
    contract = domain_contract_fixture()

    assert TemplateBuilderAPI.build_module_action_name(contract, "list") === "ListPosts"
  end
end
