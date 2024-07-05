defmodule ElixirScribe.TemplateBuilder.Options.BuildActions.BuildActionsFromOptions do
  @moduledoc false

  def build(opts) when is_list(opts) do
    no_default_actions = (opts[:no_default_actions] && true) || false

    if no_default_actions do
      actions(opts[:actions])
    else
      (ElixirScribe.resource_actions() ++ actions(opts[:actions]))
      |> Enum.uniq()
    end
  end

  defp actions(actions) when is_binary(actions) and byte_size(actions) > 0,
    do: actions |> String.split(",")

  defp actions(actions) when is_list(actions) and length(actions) > 0, do: actions
  defp actions(_actions), do: []
end
