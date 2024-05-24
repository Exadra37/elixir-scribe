defmodule <%= inspect context.web_module %>.<%= schema.web_namespace %>.<%= inspect schema.alias %>.<%= action_capitalized %>.<%= action_capitalized %><%= inspect schema.alias %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase

  import <%= inspect context.module %>Fixtures

  setup do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    %{<%= schema.singular %>: <%= schema.singular %>}
  end

  test "lists all <%= schema.plural %>", %{conn: conn} do
    conn = get(conn, ~p"<%= schema.route_prefix %>")
    assert html_response(conn, 200) =~ "Listing <%= schema.human_plural %>"
  end
end
