  alias <%= inspect schema.module %>

  @doc false
  def <%= action_first_word %>(id, attrs \\ %{}) do
    id
    |> <%= inspect context.schema.module %>API.<%= read_action %>!()
    |> <%= inspect schema.alias %>.changeset(attrs)
  end
