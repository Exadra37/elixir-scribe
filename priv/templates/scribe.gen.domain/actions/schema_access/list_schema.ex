  alias <%= inspect schema.repo %><%= schema.repo_alias %>
  alias <%= inspect schema.module %>

  @doc false
  def <%= action_first_word %>() do
    Repo.all(<%= inspect schema.alias %>)
  end
