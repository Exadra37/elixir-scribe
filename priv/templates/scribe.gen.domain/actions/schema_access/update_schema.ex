  alias <%= inspect schema.repo %><%= schema.repo_alias %>
  alias <%= inspect schema.module %>
  alias <%= inspect schema.module %>API

  @doc false
  def <%= action_first_word %>(uuid, %{} = attrs) when is_binary(uuid) and is_map(attrs) do
    uuid
    |> <%= schema.human_singular %>API.<%= read_action %>!()
    |> <%= inspect schema.alias %>.changeset(attrs)
    |> Repo.update()
  end
