defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase

  @create_attrs <%= Mix.Phoenix.to_text schema.params.create %>
  @invalid_attrs <%= Mix.Phoenix.to_text (for {key, _} <- schema.params.create, into: %{}, do: {key, nil}) %>

  test "<%= action %> <%= schema.singular %> redirects to show when data is valid", %{conn: conn} do
    conn = post(conn, ~p"<%= schema.route_prefix %>", <%= schema.singular %>: @create_attrs)

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == ~p"<%= schema.route_prefix %>/#{id}"

    conn = get(conn, ~p"<%= schema.route_prefix %>/#{id}")
    assert html_response(conn, 200) =~ "<%= schema.human_singular %> #{id}"
  end

  test "<%= action %> <%= schema.singular %> renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, ~p"<%= schema.route_prefix %>", <%= schema.singular %>: @invalid_attrs)
    assert html_response(conn, 200) =~ "<%= new_action_capitalized %> <%= schema.human_singular %>"
  end
end
