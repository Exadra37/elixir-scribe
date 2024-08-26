defmodule ElixirScribe.TemplateBuilder.Template.BuildFilename.BuildFilenameActionTemplateTest do
alias ElixirScribe.TemplateBuilderAPI
alias ElixirScribe.TemplateBuilder.BuildFilenameActionTemplateContract

  use ElixirScribe.BaseCase, async: true


  test "it builds the template filename for an action in the default resource actions" do
    attrs = %{
      action: "read",
      action_suffix: "_",
      file_type: "schema",
      file_extension: ".ex"
    }

    contract = BuildFilenameActionTemplateContract.new!(attrs)

    assert TemplateBuilderAPI.build_template_action_filename(contract) === "read_schema.ex"
  end

  test "it builds the default template filename for an action not in the the default resource actions" do
    attrs = %{
      action: "report",
      action_suffix: "_",
      file_type: "schema",
      file_extension: ".ex"
    }

    contract = BuildFilenameActionTemplateContract.new!(attrs)

    assert TemplateBuilderAPI.build_template_action_filename(contract) === "default_schema.ex"
  end
end
