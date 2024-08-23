<<<<<<< Updated upstream
 #  alias <%= inspect contract.schema.repo %><%= contract.schema.repo_alias %>
 # alias <%= inspect contract.schema.module %>
=======
  # alias <%= inspect schema.repo %><%= schema.repo_alias %>
  # alias <%= inspect schema.module %>
>>>>>>> Stashed changes

  @doc false
  def <%= action_first_word %>() do
    raise "TOOO: Implement business logic for #{__MODULE__}"
  end
