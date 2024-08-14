defmodule ElixirScribe.Mix.Option.ParseAll.ParseAllOptions do
  @moduledoc false

  alias ElixirScribe.MixAPI

  @default_opts [schema: true, context: true, no_default_actions: false, actions: nil]

  def parse(opts) when is_list(opts) do
    @default_opts
    |> Keyword.merge(opts)
    |> put_context_app(opts[:context_app])
    |> put_resource_actions()
  end

  defp put_context_app(opts, nil), do: opts

  defp put_context_app(opts, string) do
    Keyword.put(opts, :context_app, String.to_atom(string))
  end

  defp put_resource_actions(opts) do
    resource_actions = MixAPI.build_actions_from_options(opts)
    Keyword.put(opts, :resource_actions, resource_actions)
  end
end
