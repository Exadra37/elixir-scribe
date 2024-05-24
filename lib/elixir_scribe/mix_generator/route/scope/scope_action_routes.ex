defmodule ElixirScribe.MixGenerator.Route.Scope.ScopeActionRoutes do
  @moduledoc false

  alias Mix.Phoenix.Context

  @doc false
  def scope(%Context{schema: schema} = context) do
    """

      scope "/#{schema.web_path}", #{inspect(Module.concat(context.web_module, schema.web_namespace))}, as: :#{schema.web_path} do
        pipe_through :browser
        #{build_action_routes(context)}
      end
    """
  end

  defp build_action_routes(%Context{schema: schema} = context) do
    default_actions = ElixirScribe.default_actions()
    actions = ElixirScribe.MixGeneratorAPI.build_actions_from_options(context.opts)

    extra_actions = actions -- default_actions

    routes =
      for action <- extra_actions, reduce: "" do
        routes ->
          routes <> build_route_action(action, schema)
      end

    actions = actions -- extra_actions

    for action <- actions, reduce: routes do
      routes ->
        routes <> build_route_action(action, schema)
    end
  end

  defp build_route_action("create", schema) do
    assemble_route_action("post", "create", schema)
  end

  defp build_route_action("update", schema) do
    assemble_route_action("patch", "update", schema) <>
      assemble_route_action("put", "update", schema)
  end

  defp build_route_action("delete", schema) do
    assemble_route_action("delete", "delete", schema)
  end

  defp build_route_action(action, schema) do
    assemble_route_action("get", action, schema)
  end

  defp assemble_route_action(method, action, schema) do
    action_alias = ElixirScribe.get_action_alias(action)
    action_capitalized = String.capitalize(action_alias)
    endpoint = build_endpoint(action, action_alias, schema.plural)

    "\n    #{method} \"#{endpoint}\", #{inspect(schema.alias)}.#{action_capitalized}.#{action_capitalized}#{inspect(schema.alias)}Controller, :#{action}"
  end

  @http_get_actions ["read", "new", "edit", "list"]
  @resource_id_actions ["read", "update", "delete"]

  defp build_endpoint("create", _action_alias, resource), do: "/#{resource}"
  defp build_endpoint("new", _action_alias, resource), do: "/#{resource}/new"
  defp build_endpoint("edit", _action_alias, resource), do: "/#{resource}/:id/edit"

  defp build_endpoint(action, _action_alias, resource) when action in @resource_id_actions,
    do: "/#{resource}/:id"

  defp build_endpoint(action, _action_alias, resource) when action in @http_get_actions,
    do: "/#{resource}"

  defp build_endpoint(_action, action_alias, resource), do: "/#{resource}/#{action_alias}"
end
