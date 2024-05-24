defmodule <%= module_action_name %>Test do
  use <%= inspect context.base_module %>.DataCase

  alias <%= module_action_name %>

  @doc false
  test "<%= action_first_word %> works as expected" do
    raise "TODO: Implement test for action `<%= action_first_word %>` at `<%= module_action_name %>`"
  end
end
