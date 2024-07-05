  alias <%= inspect schema.repo %><%= schema.repo_alias %>
  alias <%= inspect schema.module %>API

  @doc false
  def <%= action_first_word %>(id) do
    id
    |> <%= schema.human_singular %>API.<%= read_action %>!()
    |> Repo.delete()
  end
