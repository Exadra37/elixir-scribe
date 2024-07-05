  alias <%= absolute_module_action_name %>
  alias <%= inspect schema.module %>

  @invalid_attrs <%= Mix.Phoenix.to_text for {key, _} <- schema.params.create, into: %{}, do: {key, nil} %>

  test "<%= action_first_word %>/1 with valid data creates a <%= schema.singular %>" do
    valid_attrs = <%= Mix.Phoenix.to_text schema.params.create %>

    assert {:ok, %<%= inspect schema.alias %>{} = <%= schema.singular %>} = <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>(valid_attrs)
    <%= for {field, value} <- schema.params.create do %>
    assert <%= schema.singular %>.<%= field %> == <%= Mix.Phoenix.Schema.value(schema, field, value) %><% end %>
  end

  test "<%= action_first_word %>/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>(@invalid_attrs)
  end
