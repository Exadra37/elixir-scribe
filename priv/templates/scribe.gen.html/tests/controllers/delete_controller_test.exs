defmodule <%= inspect context.web_module %>.<%= schema.web_namespace %>.<%= inspect schema.alias %>.<%= action_capitalized %>.<%= action_capitalized %><%= inspect schema.alias %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase

  import <%= inspect context.module %>Fixtures

  setup do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    %{<%= schema.singular %>: <%= schema.singular %>}
  end

  test "deletes chosen <%= schema.singular %>", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
    conn = delete(conn, ~p"<%= schema.route_prefix %>/#{<%= schema.singular %>}")
    assert redirected_to(conn) == ~p"<%= schema.route_prefix %>"

    assert_error_sent 404, fn ->
      get(conn, ~p"<%= schema.route_prefix %>/#{<%= schema.singular %>}")
    end
  end
end
