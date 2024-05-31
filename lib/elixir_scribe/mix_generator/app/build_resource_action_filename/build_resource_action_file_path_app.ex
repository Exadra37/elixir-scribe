defmodule ElixirScribe.MixGenerator.App.BuildResourceActionFilePath.BuildResourceActionFilePathApp do

  # alias Mix.Phoenix.Context
  alias  ElixirScribe.MixGenerator.AppApiContract.BuildResourceActionFilePathContract

  @doc false
  # def build(%Context{} = context, action, suffix, type) do
  def build(%BuildResourceActionFilePathContract{} = contract) do
    resource_path = ElixirScribe.build_app_resource_path(contract.context, contract.path_type)
    filename = build_app_resource_action_filename(contract)

    Path.join([resource_path, "#{contract.action}", filename])
  end

  @doc false
  # def build_app_resource_action_test_file_path(%Context{} = context, action, type) do
  #   build_app_resource_action_file_path(context, action, "_test.exs", type)
  # end

  defp build_app_resource_action_filename(contract) do
    %{action: action, context: context, file_type: file_type, file_extension: file_extension} = contract

    resource =
      (action in ElixirScribe.resource_plural_actions() && context.schema.plural) || context.schema.singular

    # "#{action_suffix}#{filename}"

    "#{action}_" <> resource <> file_type <> file_extension
  end
end
