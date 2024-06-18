defmodule ElixirScribe.DomainGenerator.Resource.BuildActionFilesPaths.BuildActionFilesPathsResource do
  @moduledoc false

  alias Mix.Scribe.Context
  alias ElixirScribe.MixGeneratorAPI

  @doc false
  def build(%Context{generate?: false}), do: []
  def build(%Context{generate?: true} = context), do: build_files(context)

  defp build_files(%Context{} = context) do
    resource_actions = context.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions do
      source_path = build_source_path(context.schema, action)
      filename = build_filename(context, action)
      target_path = Path.join([context.lib_resource_dir, action, filename])

      {:eex, :resource, source_path, target_path, action}
    end
  end

  defp build_filename(context, action) do
    plural_actions = ElixirScribe.resource_plural_actions()
    resource_name = action in plural_actions && context.resource_name_plural || context.resource_name_singular
    "#{action}_" <> resource_name <> ".ex"
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
