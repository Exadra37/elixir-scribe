  alias <%= inspect schema.repo %><%= schema.repo_alias %>
  alias <%= inspect schema.module %>API

  @doc false
  def <%= action_first_word %>(%{} = attrs) attrs !== %{} do
    attrs
    |> <%= inspect schema.alias %>API.new()
    |> Repo.insert()
  end
