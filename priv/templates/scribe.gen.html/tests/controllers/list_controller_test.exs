defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase

  import <%= context.schema.module %>Fixtures

  setup do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    %{<%= schema.singular %>: <%= schema.singular %>}
  end

  test "lists all <%= schema.plural %>", %{conn: conn} do
    conn = get(conn, ~p"<%= schema.route_prefix %>")
    assert html_response(conn, 200) =~ "Listing <%= schema.human_plural %>"
  end
end
