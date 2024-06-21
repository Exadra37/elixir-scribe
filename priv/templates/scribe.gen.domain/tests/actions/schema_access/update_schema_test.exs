  alias <%= absolute_module_action_name %>
  alias <%= inspect schema.module %>
  alias <%= inspect schema.module %><%= "." <> read_action_capitalized <> "." <> read_action_capitalized <> schema.human_singular %>

  import <%= context.schema.module %>Fixtures

  @invalid_attrs <%= Mix.Phoenix.to_text for {key, _} <- schema.params.create, into: %{}, do: {key, nil} %>

  test "<%= action_first_word %>/2 with valid data updates the <%= schema.singular %>" do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    update_attrs = <%= Mix.Phoenix.to_text schema.params.update%>

    assert {:ok, %<%= inspect schema.alias %>{} = <%= schema.singular %>} = <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>(<%= schema.singular %>.id, update_attrs)
    <%= for {field, value} <- schema.params.update do %>
    assert <%= schema.singular %>.<%= field %> == <%= Mix.Phoenix.Schema.value(schema, field, value) %><% end %>
  end

  test "<%= action_first_word %>/2 with invalid data returns error changeset" do
    <%= schema.singular %> = <%= schema.singular %>_fixture()
    assert {:error, %Ecto.Changeset{}} = <%= action_capitalized %><%= schema.human_singular <> "." <> action_first_word %>(<%= schema.singular %>.id, @invalid_attrs)
    assert <%= schema.singular %> == <%= read_action_capitalized %><%= schema.human_singular <> "." <> read_action %>!(<%= schema.singular %>.id)
  end
