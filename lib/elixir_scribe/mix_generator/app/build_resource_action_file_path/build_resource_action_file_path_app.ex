defmodule ElixirScribe.MixGenerator.App.BuildResourceActionFilePath.BuildResourceActionFilePathApp do
  @moduledoc false

  alias ElixirScribe.MixGenerator.AppAPI
  alias  ElixirScribe.MixGenerator.AppAPIContract.BuildResourceActionFilePathContract
  alias  ElixirScribe.MixGenerator.AppAPIContract.BuildDomainPathContract


  # def build(%Context{} = context, action, suffix, type) do
  def build(%BuildResourceActionFilePathContract{} = contract) do
    resource_path = AppAPI.build_resource_path(contract.context, contract.path_type)
    filename = build_app_resource_action_filename(contract)

    Path.join([resource_path, "#{contract.action}", filename])
  end

  defp build_app_resource_action_filename(contract) do
    %{action: action, context: context, file_type_prefix: file_type_prefix, file_type: file_type, file_extension: file_extension} = contract

    resource =
      (action in ElixirScribe.resource_plural_actions() && context.schema.plural) || context.schema.singular

    "#{action}_" <> resource <> file_type_prefix <> file_type <> file_extension
  end
end
