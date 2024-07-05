  alias <%= inspect schema.module %>
  alias <%= inspect schema.module %>API

  @doc false
  def <%= action_first_word %>(id, attrs \\ %{}) when is_map(attrs) do
    id
    |> <%= inspect schema.alias %>API.<%= read_action %>!()
    |> <%= inspect schema.alias %>.changeset(attrs)
  end
