defmodule ElixirScribe.TemplateBuilder.Route.Scope.ScopeActionRoutes do
  @moduledoc false

  alias ElixirScribe.TemplateBuilderAPI
  alias Mix.Scribe.Context

  def scope(%Context{schema: schema} = context) do
    resource = schema.plural
    controller = inspect(context.web_resource_module)
    scope_alias = String.replace(schema.web_path, "/", "_") <> "_" <> resource

    """

      scope "/#{schema.web_path}/#{resource}", #{controller}, as: :#{scope_alias} do
        pipe_through :browser
        #{build_action_routes(context)}
      end
    """
  end

  defp build_action_routes(%Context{} = context) do
    default_resource_actions = ElixirScribe.resource_actions()

    resource_actions = context.opts |> Keyword.get(:resource_actions)

    extra_actions = resource_actions -- default_resource_actions

    routes =
      for action <- extra_actions, reduce: "" do
        routes ->
          routes <> build_route_action(action, context)
      end

    actions = resource_actions -- extra_actions

    for action <- actions, reduce: routes do
      routes ->
        routes <> build_route_action(action, context)
    end
  end

  defp build_route_action("create", context) do
    assemble_route_action("post", "create", context)
  end

  defp build_route_action("update", context) do
    assemble_route_action("patch", "update", context) <>
      assemble_route_action("put", "update", context)
  end

  defp build_route_action("delete", context) do
    assemble_route_action("delete", "delete", context)
  end

  defp build_route_action(action, context) do
    assemble_route_action("get", action, context)
  end

  defp assemble_route_action(method, action, context) do
    action_alias = ElixirScribe.resource_action_alias(action)
    endpoint = build_endpoint(action, action_alias)
    controller = build_controller(context, action, action_alias)

    "\n    #{method} \"#{endpoint}\", #{controller}, :#{action_alias}"
  end

  @http_get_actions ["read", "new", "edit", "list"]
  @resource_id_actions ["read", "update", "delete"]

  defp build_endpoint("create", _action_alias), do: "/"
  defp build_endpoint("new", action_alias), do: "/#{action_alias}"
  defp build_endpoint("edit", action_alias), do: "/:id/#{action_alias}"

  defp build_endpoint(action, _action_alias) when action in @resource_id_actions,
    do: "/:id"

  defp build_endpoint(action, _action_alias) when action in @http_get_actions,
    do: "/"

  defp build_endpoint(_action, action_alias), do: "/#{action_alias}"

  defp build_controller(context, action, action_alias) do
    action_capitalized = String.capitalize(action_alias)
    module_action_name = TemplateBuilderAPI.build_module_action_name(context, action, file_type: :controller)

    "#{action_capitalized}.#{module_action_name}Controller"
  end
end
