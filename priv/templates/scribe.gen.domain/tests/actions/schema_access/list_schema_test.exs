  alias <%= absolute_module_action_name %>

  import <%= context.schema.module %>Fixtures

  test "<%= action_first_word %>/0 returns all <%= schema.plural %>" do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    assert <%= action_capitalized <> schema.human_plural <> "." <> action_first_word %>() == [<%= schema.singular %>]
  end
