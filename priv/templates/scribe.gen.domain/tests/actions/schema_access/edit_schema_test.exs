  alias <%= module_action_name %>

  import <%= inspect(context.base_module) <> "." <> inspect(context.alias) %>Fixtures

  test "<%= action_first_word %>/1 returns a <%= schema.singular %> changeset" do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    assert %Ecto.Changeset{} = <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>(<%= schema.singular %>.id)
  end
