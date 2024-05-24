defmodule <%= inspect context.web_module %>.<%= schema.web_namespace %>.<%= inspect schema.alias %>.<%= action_capitalized %>.<%= action_capitalized %><%= inspect schema.alias %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase

  import <%= inspect context.module %>Fixtures

  setup do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    %{<%= schema.singular %>: <%= schema.singular %>}
  end

  test "<%= action %> <%= schema.singular %> renders form", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
    conn = get(conn, ~p"<%= schema.route_prefix %>/#{<%= schema.singular %>.id}")
    assert html_response(conn, 200) =~ "<%= schema.human_singular %>"
  end
end
