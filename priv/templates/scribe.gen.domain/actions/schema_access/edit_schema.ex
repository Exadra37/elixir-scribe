  alias <%= inspect schema.module %>
  alias <%= inspect schema.module %>API

  @doc false
  def <%= action_first_word %>(uuid, attrs \\ %{}) when is_binary(uuid) and is_map(attrs) do
    uuid
    |> <%= inspect schema.alias %>API.<%= read_action %>!()
    |> <%= inspect schema.alias %>.changeset(attrs)
  end
