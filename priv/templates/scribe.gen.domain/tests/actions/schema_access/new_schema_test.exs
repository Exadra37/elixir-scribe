  alias <%= module_action_name %>

  test "<%= action_first_word %>/1 returns a <%= schema.singular %> changeset" do
    assert %Ecto.Changeset{} = <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>()
  end
