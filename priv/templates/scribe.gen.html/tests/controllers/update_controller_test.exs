defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase

  import <%= context.schema.module %>Fixtures

  @update_attrs <%= Mix.Phoenix.to_text schema.params.update %>
  @invalid_attrs <%= Mix.Phoenix.to_text (for {key, _} <- schema.params.create, into: %{}, do: {key, nil}) %>

  setup do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    %{<%= schema.singular %>: <%= schema.singular %>}
  end

  test "<%= action %> <%= schema.singular %> redirects when data is valid", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
    conn = put(conn, ~p"<%= schema.route_prefix %>/#{<%= schema.singular %>}", <%= schema.singular %>: @update_attrs)
    assert redirected_to(conn) == ~p"<%= schema.route_prefix %>/#{<%= schema.singular %>}"

    conn = get(conn, ~p"<%= schema.route_prefix %>/#{<%= schema.singular %>}")<%= if schema.string_attr do %>
    assert html_response(conn, 200) =~ <%= inspect Mix.Scribe.Schema.default_param(schema, :update) %><% else %>
    assert html_response(conn, 200)<% end %>
  end

  test "renders errors when data is invalid", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
    conn = put(conn, ~p"<%= schema.route_prefix %>/#{<%= schema.singular %>}", <%= schema.singular %>: @invalid_attrs)
    assert html_response(conn, 200) =~ "<%= edit_action_capitalized %> <%= schema.human_singular %>"
    end
end
