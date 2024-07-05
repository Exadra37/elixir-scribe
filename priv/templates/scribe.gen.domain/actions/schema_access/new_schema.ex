  alias <%= inspect schema.module %>

  @doc false
  def <%= action_first_word %>(attrs \\ %{}) when is_map(attrs) do
    <%= inspect schema.alias %>.changeset(%<%= schema.human_singular %>{}, attrs)
  end
