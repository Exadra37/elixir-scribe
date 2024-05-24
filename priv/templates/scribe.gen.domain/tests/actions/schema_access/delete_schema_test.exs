  alias <%= module_action_name %>
  alias <%= inspect schema.module %>
  alias <%= inspect(context.base_module) <> "." <> inspect(context.alias) <> "." <> inspect(schema.alias) <> "." <> read_action_capitalized <> "." <>read_action_capitalized <> schema.human_singular %>

  import <%= inspect(context.base_module) <> "." <> inspect(context.alias) %>Fixtures

  test "<%= action_first_word %>/1 deletes the <%= schema.singular %>" do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    assert {:ok, %<%= inspect schema.alias %>{}} = <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>(<%= schema.singular %>.id)
    assert_raise Ecto.NoResultsError, fn -> <%= read_action_capitalized %><%= schema.human_singular %>.<%= read_action %>!(<%= schema.singular %>.id) end
  end
