defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase

  test "<%= action %> <%= schema.singular %> renders form", %{conn: conn} do
    conn = get(conn, ~p"<%= schema.route_prefix %>/<%= action %>")
    assert html_response(conn, 200) =~ "<%= action_capitalized %> <%= schema.human_singular %>"
  end
end
