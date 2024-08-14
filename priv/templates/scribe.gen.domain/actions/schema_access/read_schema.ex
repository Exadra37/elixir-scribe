  alias <%= inspect schema.repo %><%= schema.repo_alias %>
  alias <%= inspect schema.module %>

  @doc false
  def <%= action_first_word %>!(uuid) when is_binary(uuid), do: Repo.get!(<%= inspect schema.alias %>, uuid)
