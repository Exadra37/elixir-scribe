defmodule ElixirScribe.Generator.Domain.Resource.BuildTestActionFilesPaths.BuildTestActionFilesPathsResource do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.TemplateBuilderAPI

  @doc false
  def build(%DomainContract{generate?: false}), do: []
  def build(%DomainContract{generate?: true} = context), do: build_files(context)

  defp build_files(%DomainContract{} = context) do
    resource_actions = context.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions do
      source_path = build_source_path(context.schema, action)
      target_path = build_target_path(context, action)

      {:eex, :resource_test, source_path, target_path, action}
    end
  end

  defp build_target_path(context, action) do
    plural_actions = ElixirScribe.resource_plural_actions()
    resource_name = action in plural_actions && context.resource_name_plural || context.resource_name_singular
    filename= "#{action}_" <> resource_name <> "_test.exs"

    Path.join([context.test_resource_dir, action, filename])
  end

  defp build_source_path(schema, action) do
    resource_action_path = ElixirScribe.resource_test_actions_template_path()
    schema_folder = ElixirScribe.schema_template_folder_name(schema)
    action_template_filename = build_template_action_filename(action, schema.generate?)

    Path.join([resource_action_path, schema_folder, action_template_filename])
  end

  defp build_template_action_filename(action, true) do
    TemplateBuilderAPI.build_template_action_filename(action, "_", "schema", "_test.exs")
  end
  defp build_template_action_filename(_action, false), do: "action_test_no_schema_access.exs"
end
