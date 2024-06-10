defmodule ElixirScribe.MixGenerator.App.BuildResourceActionFilePath.BuildResourceActionFilePathApp do
  @moduledoc false

  alias ElixirScribe.MixGenerator.AppAPI
  # alias  ElixirScribe.MixGenerator.AppAPIContract.BuildResourcePathContract
  alias  ElixirScribe.MixGenerator.AppAPIContract.BuildResourceActionFilePathContract

  # def build(%Context{} = context, action, suffix, type) do
  def build(%BuildResourceActionFilePathContract{} = contract) do
    # resource_path = AppAPI.build_resource_path(contract)
    filename = build_app_resource_action_filename(contract)

    resource_dir = resource_dir(contract.path_type, contract.context)

    Path.join([resource_dir, contract.action, filename])
    |> dbg()
  end

  defp resource_dir(:lib_web, context), do: context.lib_web_resource_dir
  defp resource_dir(:lib_core, context), do: context.lib_resource_dir
  defp resource_dir(:test_web_core, context), do: context.test_web_resource_dir
  defp resource_dir(:test_core, context), do: context.test_resource_dir



  defp build_app_resource_action_filename(contract) do
    %{action: action, context: context, file_type_prefix: file_type_prefix, file_type: file_type, file_extension: file_extension} = contract

    resource =
      (action in ElixirScribe.resource_plural_actions() && context.schema.plural) || context.schema.singular

    "#{action}_" <> resource <> file_type_prefix <> file_type <> file_extension
  end
end
