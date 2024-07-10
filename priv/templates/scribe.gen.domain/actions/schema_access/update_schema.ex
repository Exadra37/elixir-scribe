  alias <%= inspect schema.repo %><%= schema.repo_alias %>
  alias <%= inspect schema.module %>
  alias <%= inspect schema.module %>API

  @doc false
  def <%= action_first_word %>(id, %{} = attrs) do
    id
    |> <%= schema.human_singular %>API.<%= read_action %>!()
    |> <%= inspect schema.alias %>.changeset(attrs)
    |> Repo.update()
  end