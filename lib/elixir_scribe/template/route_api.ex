defmodule ElixirScribe.TemplateRouteAPI do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Template.Route.Scope.ScopeActionRoutes

  def scope_routes(%DomainContract{} = contract), do: ScopeActionRoutes.scope(contract)
end
