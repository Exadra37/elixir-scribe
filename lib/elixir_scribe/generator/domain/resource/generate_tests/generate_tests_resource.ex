defmodule ElixirScribe.Generator.Domain.Resource.GenerateTests.GenerateTestsResource do
  @moduledoc false

  alias ElixirScribe.TemplateBindingAPI
  alias ElixirScribe.Generator.DomainResourceAPI
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.TemplateFileAPI

  def generate(%DomainContract{generate?: false} = contract), do: contract
  def generate(%DomainContract{generate?: true} = contract) do
    base_template_paths = ElixirScribe.base_template_paths()
    binding = TemplateBindingAPI.build_binding_template(contract)

    for {:eex, :resource_test, source_path, target_path, action} <- DomainResourceAPI.build_test_action_files_paths(contract) do
      contract = %{contract | test_file: target_path}

      unless File.exists?(contract.test_file) do
        binding = TemplateBindingAPI.rebuild_binding_template(binding, action, file_type: :lib_core)

        # When the file already exists we are asked if we want to overwrite it.
        created_or_overwritten? =
          create_test_action_module_file(base_template_paths, target_path, binding, contract.schema.generate?)

        if created_or_overwritten? do
          inject_action_function_into_module(base_template_paths, source_path, target_path, binding)
        end
      end
    end

    contract
  end

  defp create_test_action_module_file(base_template_paths, target_path, binding, schema_generate?) do
    module_template_path = build_module_template_path(schema_generate?)
    content = Mix.Phoenix.eval_from(base_template_paths, module_template_path, binding)

    Mix.Generator.create_file(target_path, content)
  end

  defp build_module_template_path(true) do
    ElixirScribe.resource_test_actions_template_path()
    |> Path.join("action_test.exs")
  end
  defp build_module_template_path(false) do
    ElixirScribe.resource_test_actions_template_path()
    |> Path.join("action_test_no_schema_access.exs")
  end

  defp inject_action_function_into_module(base_template_paths, source_path, target_path, binding) do
    base_template_paths
    |> Mix.Phoenix.eval_from(source_path, binding)
    |> TemplateFileAPI.inject_eex_before_final_end(target_path, binding)
  end
end
