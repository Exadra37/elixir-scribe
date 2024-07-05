defmodule ElixirScribe.TemplateBuilder.Template.BuildFilename.BuildFilenameActionTemplate do
  @moduledoc false

  @doc false
  def build(action, action_suffix, file_type, file_extension) do
    case action in ElixirScribe.resource_actions() do
      true ->
        "#{action}#{action_suffix}#{file_type}#{file_extension}"

      false ->
        "default#{action_suffix}#{file_type}#{file_extension}"
    end
  end
end
