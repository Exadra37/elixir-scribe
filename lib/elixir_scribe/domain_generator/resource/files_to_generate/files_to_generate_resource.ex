defmodule ElixirScribe.DomainGenerator.Resource.FilesToGenerate.FilesToGenerateResource do
  @moduledoc false

  alias Mix.Phoenix.Context
  alias ElixirScribe.MixGeneratorAPI
  alias ElixirScribe.MixGenerator.AppApi
  alias ElixirScribe.MixGenerator.AppApiContract.BuildResourceActionFilePathContract

  @doc false
  def files(%Context{generate?: false}), do: []
  def files(%Context{generate?: true} = context), do: build_resource_action_files(context)

  defp build_resource_action_files(%Context{} = context) do
    for action <- MixGeneratorAPI.build_actions_from_options(context.opts) do
      source_path = build_source_path(context.schema, action)

      api_contract = BuildResourceActionFilePathContract.new!(%{
        context: context,
        action: action,
        file_extension: ".ex",
        file_type: "",
        path_type: :lib_core
      })

      target_path = AppApi.build_resource_action_file_path(api_contract)

      {:eex, source_path, target_path, action}
    end
  end

  defp build_source_path(schema, action) do
    domain_path = ElixirScribe.resource_actions_template_path()
    schema_folder = ElixirScribe.schema_template_folder_name(schema)

    action_template_filename =
      if schema.generate? do
        MixGeneratorAPI.build_template_action_filename(action, "_", "schema", ".ex")
      else
        "any_action.ex"
      end

    Path.join([domain_path, schema_folder, action_template_filename])
  end
end
