defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase

  test "<%= action %> <%= schema.singular %>", %{conn: _conn} do
    raise "Test not implemented yet..."
  end
end
