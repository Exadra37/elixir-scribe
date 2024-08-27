defmodule ElixirScribe.TemplateFileAPITest do
  alias ElixirScribe.Template.BuildFilenameForActionFileContract
  alias ElixirScribe.TemplateFileAPI
  use ElixirScribe.BaseCase, async: true

  describe "build_dir_path_for_html_file/1" do
    test "it returns a string" do
      contract = domain_contract_fixture()

      assert TemplateFileAPI.build_dir_path_for_html_file(contract) |> is_binary()
    end
  end

  describe "build_template_action_filename/1" do
    test "it returns a string" do
      attrs = %{
        action: "read",
        action_suffix: "_",
        file_type: "schema",
        file_extension: ".ex"
      }

      contract = BuildFilenameForActionFileContract.new!(attrs)

      assert TemplateFileAPI.build_template_action_filename(contract) |> is_binary()
    end
  end
end
