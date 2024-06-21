  alias <%= absolute_module_action_name %>
  alias <%= inspect schema.module %>
  alias <%= inspect schema.module %><%= "." <> read_action_capitalized <> "." <> read_action_capitalized <> schema.human_singular %>

  import <%= context.schema.module %>Fixtures

  test "<%= action_first_word %>/1 deletes the <%= schema.singular %>" do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    assert {:ok, %<%= inspect schema.alias %>{}} = <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>(<%= schema.singular %>.id)
    assert_raise Ecto.NoResultsError, fn -> <%= read_action_capitalized %><%= schema.human_singular %>.<%= read_action %>!(<%= schema.singular %>.id) end
  end
