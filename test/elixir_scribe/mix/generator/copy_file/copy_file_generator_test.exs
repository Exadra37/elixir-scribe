Code.require_file("test/mix_test_helper.exs")

defmodule ElixirScribe.Mix.Generator.CopyFile.CopyFileGeneratorTest do

  alias ElixirScribe.TemplateBindingAPI
  alias ElixirScribe.MixAPI
  use ElixirScribe.BaseCase, async: true

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "it copy files from template to destination", config do
    in_tmp_project(config.test, fn ->
      dbg(config)
      # tmp_path = random_tmp_path(config.test)
      tmp_path = "."

      schema_template_path = tmp_path |> Path.join("priv/templates/schema_template.ex")
      api_template_path = tmp_path |> Path.join("priv/templates/api_template.ex")
      resource_template_path = tmp_path |> Path.join("priv/templates/resource_template.ex")

      schema_content = """
      defmodule SchemaTemplate do
        def changeset() do
          <%= @action %>
        end
      end
      """

      File.write(schema_template_path, schema_content)

      api_content = """
      defmodule API do
        def <%= @action %>() do
          <%= @action %>
        end
      end
      """

      File.write(api_template_path, api_content)

      resource_content = """
      defmodule CreateResource do
        def <%= @action %>() do
          <%= @action %>
        end
      end
      """

      File.write(resource_template_path, resource_content)

      paths = ElixirScribe.base_template_paths()

      contract = domain_contract_fixture()
      binding = TemplateBindingAPI.build_binding_template(contract)

      mapping = [
        {:eex, schema_template_path, "schema.ex"},
        {:eex, :api, api_template_path, "api.ex"},
        {:eex, :resource, resource_template_path, "create_resource.ex", "create"},
      ]

      MixAPI.copy_file(paths, ".", binding, mapping)

      assert_file("schema.ex", fn file ->
        assert file === schema_content
      end)
    end)
  end
end
