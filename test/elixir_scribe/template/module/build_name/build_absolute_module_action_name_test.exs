defmodule ElixirScribe.Template.Module.BuildName.BuildAbsoluteModuleActionNameTest do
  alias ElixirScribe.TemplateModuleAPI
  use ElixirScribe.BaseCase, async: true

  test "it builds the absolute module name for the given action" do
    contract = domain_contract_fixture()

    assert TemplateModuleAPI.build_absolute_module_action_name(contract, "read",
             file_type: :lib_core
           ) === "ElixirScribe.Site.Blog.Post.Read.ReadPost"
  end
end
