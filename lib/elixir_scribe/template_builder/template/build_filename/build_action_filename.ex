defmodule ElixirScribe.TemplateBuilder.Template.BuildFilename.BuildFilenameActionTemplate do
  @moduledoc false
alias ElixirScribe.TemplateBuilder.BuildFilenameActionTemplateContract

  @doc false
  def build(%BuildFilenameActionTemplateContract{} = contract) do
    case contract.action in ElixirScribe.resource_actions() do
      true ->
        "#{contract.action}#{contract.action_suffix}#{contract.file_type}#{contract.file_extension}"

      false ->
        "default#{contract.action_suffix}#{contract.file_type}#{contract.file_extension}"
    end
  end
end
