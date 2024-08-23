defmodule ElixirScribe.Generator.Domain.Resource.GenerateApi.GenerateApiResource do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.TemplateBuilderAPI
  alias ElixirScribe.Generator.Domain.ResourceAPI

  def generate(%DomainContract{generate?: false}), do: []
  def generate(%DomainContract{generate?: true} = contract) do
    base_template_paths = ElixirScribe.base_template_paths()
    binding = TemplateBuilderAPI.build_binding_template(contract)

    contract
    |> ensure_api_file_exists(base_template_paths, binding)
    |> inject_api_functions(base_template_paths, binding)

    contract
  end

  defp build_api_binding(contract, binding) do
    Keyword.merge(binding,
      absolute_module_name:
        ElixirScribe.TemplateBuilderAPI.build_absolute_module_name(contract, file_type: :lib_core),
      aliases:
        ElixirScribe.TemplateBuilderAPI.build_absolute_module_action_name_aliases(contract, file_type: :lib_core)
    )
  end

  defp ensure_api_file_exists(contract, base_template_paths, binding) do
    binding = build_api_binding(contract, binding)

    unless File.exists?(contract.api_file) do
      {:eex, :api, source_path, target_path} = ResourceAPI.build_api_file_paths(contract)

      Mix.Generator.create_file(
        target_path,
        Mix.Phoenix.eval_from(base_template_paths, source_path, binding)
      )
    end

    contract
  end

  defp inject_api_functions(contract, base_template_paths, binding) do
    resource_actions = contract.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions do
      binding =
        build_api_binding(contract, binding)
        |> TemplateBuilderAPI.rebuild_binding_template(action, file_type: :lib_core)

      api_action_template_path =
        if contract.schema.generate? do
          action_template_filename =
            TemplateBuilderAPI.build_template_action_filename(action, "_", "api_function", ".ex")

          ElixirScribe.domain_api_template_path() |> Path.join(action_template_filename)
        else
          ElixirScribe.domain_api_template_path()
          |> Path.join("api_function_no_schema_access.ex")
        end

      base_template_paths
      |> Mix.Phoenix.eval_from(api_action_template_path, binding)
      |> TemplateBuilderAPI.inject_eex_before_final_end(contract.api_file, binding)
    end
  end
end
