defmodule <%= inspect context.web_module %>.<%= schema.web_namespace %>.<%= inspect schema.alias %>.<%= action_capitalized %>.<%= action_capitalized %><%= inspect schema.alias %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase

  test "<%= action %> <%= schema.singular %>", %{conn: _conn} do
    raise "Test not implemented yet..."
  end
end
