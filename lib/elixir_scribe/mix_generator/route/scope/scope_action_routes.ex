defmodule ElixirScribe.MixGenerator.Route.Scope.ScopeActionRoutes do
  @moduledoc false

  alias Mix.Scribe.Context

  @doc false
  def scope(%Context{schema: schema} = context) do
    resource = schema.plural
    controller = inspect(Module.concat(context.web_module, schema.web_namespace))
    scope_alias = String.replace(schema.web_path, "/", "_") <> "_" <> resource

    """

      scope "/#{schema.web_path}/#{resource}", #{controller}, as: :#{scope_alias} do
        pipe_through :browser
        #{build_action_routes(context)}
      end
    """
  end

  defp build_action_routes(%Context{schema: schema} = context) do
    default_resource_actions = ElixirScribe.resource_actions()

    resource_actions = context.opts |> Keyword.get(:resource_actions)

    extra_actions = resource_actions -- default_resource_actions

    routes =
      for action <- extra_actions, reduce: "" do
        routes ->
          routes <> build_route_action(action, schema)
      end

    actions = resource_actions -- extra_actions

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
    action_alias = ElixirScribe.resource_action_alias(action)
    action_capitalized = String.capitalize(action_alias)
    endpoint = build_endpoint(action, action_alias)

    "\n    #{method} \"#{endpoint}\", #{inspect(schema.alias)}.#{action_capitalized}.#{action_capitalized}#{inspect(schema.alias)}Controller, :#{action}"
  end

  @http_get_actions ["read", "new", "edit", "list"]
  @resource_id_actions ["read", "update", "delete"]

  defp build_endpoint("create", _action_alias), do: "/"
  defp build_endpoint("new", _action_alias), do: "/new"
  defp build_endpoint("edit", _action_alias), do: "/:id/edit"

  defp build_endpoint(action, _action_alias) when action in @resource_id_actions,
    do: "/:id"

  defp build_endpoint(action, _action_alias) when action in @http_get_actions,
    do: "/"

  defp build_endpoint(_action, action_alias), do: "/#{action_alias}"
end
