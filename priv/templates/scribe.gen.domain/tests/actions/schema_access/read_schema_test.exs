  alias <%= absolute_module_action_name %>

  import <%= context.schema.module %>Fixtures

  test "<%= action_first_word %>!/1 returns the <%= schema.singular %> with given id" do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    assert <%= action_capitalized %><%= schema.human_singular <> "." <> action_first_word %>!(<%= schema.singular %>.id) == <%= schema.singular %>
  end
