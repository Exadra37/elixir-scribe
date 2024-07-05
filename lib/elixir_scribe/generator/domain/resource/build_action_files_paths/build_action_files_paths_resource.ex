defmodule ElixirScribe.Generator.Domain.Resource.BuildActionFilesPaths.BuildActionFilesPathsResource do
  @moduledoc false

  alias Mix.Scribe.Context
  alias ElixirScribe.TemplateBuilderAPI

  @doc false
  def build(%Context{generate?: false}), do: []
  def build(%Context{generate?: true} = context), do: build_files(context)

  defp build_files(%Context{} = context) do
    resource_actions = context.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions do
      source_path = build_source_path(context.schema, action)
      target_path = build_target_path(context, action)

      {:eex, :resource, source_path, target_path, action}
    end
  end

  defp build_target_path(context, action) do
    plural_actions = ElixirScribe.resource_plural_actions()
    resource_name = action in plural_actions && context.resource_name_plural || context.resource_name_singular
    filename = "#{action}_" <> resource_name <> ".ex"

    Path.join([context.lib_resource_dir, action, filename])
  end

  defp build_source_path(schema, action) do
    resource_action_path = ElixirScribe.resource_actions_template_path()
    schema_folder = ElixirScribe.schema_template_folder_name(schema)
    action_template_filename = build_template_action_filename(action, schema.generate?)

    Path.join([resource_action_path, schema_folder, action_template_filename])
  end

  defp build_template_action_filename(action, true) do
    TemplateBuilderAPI.build_template_action_filename(action, "_", "schema", ".ex")
  end
  defp build_template_action_filename(_action, false), do: "any_action.ex"
end
