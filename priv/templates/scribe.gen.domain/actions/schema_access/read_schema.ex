  alias <%= inspect schema.repo %><%= schema.repo_alias %>
  alias <%= inspect schema.module %>

  @doc false
  def <%= action_first_word %>!(id), do: Repo.get!(<%= inspect schema.alias %>, id)
