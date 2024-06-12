defmodule ElixirScribe.DomainGenerator.Resource.GenerateApi.GenerateApiResource do
  @moduledoc false

  alias Mix.Scribe.Context
  alias ElixirScribe.MixGeneratorAPI

  @doc false
  def generate(%Context{} = context) do
    base_template_paths = ElixirScribe.base_template_paths()
    binding = MixGeneratorAPI.build_binding_template(context)

    context
    |> ensure_api_file_exists(base_template_paths, binding)
    |> inject_api_functions(base_template_paths, binding)

    context
  end

  defp build_api_binding(context, binding) do
    Keyword.merge(binding,
      module_name:
        ElixirScribe.MixGeneratorAPI.build_absolute_module_name(context, from_schema: true),
      aliases:
        ElixirScribe.MixGeneratorAPI.build_absolute_module_action_name_aliases(context,
          from_schema: true
        )
    )
  end

  defp ensure_api_file_exists(context, base_template_paths, binding) do
    binding = build_api_binding(context, binding)

    unless Context.pre_existing?(context) do
      api_module_path =
        ElixirScribe.domain_api_template_path() |> Path.join("api_module.ex")

      Mix.Generator.create_file(
        context.api_file,
        Mix.Phoenix.eval_from(base_template_paths, api_module_path, binding)
      )
    end

    context
  end

  defp inject_api_functions(context, base_template_paths, binding) do
    resource_actions = context.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions do
      binding = build_api_binding(context, binding) |> MixGeneratorAPI.rebuild_binding_template(action)

      api_action_template_path =
        if context.schema.generate? do
          action_template_filename =
            MixGeneratorAPI.build_template_action_filename(action, "_", "api_function", ".ex")

          ElixirScribe.domain_api_template_path() |> Path.join(action_template_filename)
        else
          ElixirScribe.domain_api_template_path()
          |> Path.join("api_function_no_schema_access.ex")
        end

      base_template_paths
      |> Mix.Phoenix.eval_from(api_action_template_path, binding)
      |> MixGeneratorAPI.inject_eex_before_final_end(context.api_file, binding)
    end
  end
end
