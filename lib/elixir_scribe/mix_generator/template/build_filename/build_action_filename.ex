defmodule ElixirScribe.MixGenerator.Template.BuildFilename.BuildFilenameActionTemplate do
  @moduledoc false

  @doc false
  def build(action, filename, action_suffix) do
    case action in ElixirScribe.resource_actions() do
      true ->
        "#{action}#{action_suffix}#{filename}"

      false ->
        "default#{action_suffix}#{filename}"
    end
  end
end
