
  @doc """
  Gets the <%= schema.singular %> for the given `uuid`.

  Raises `Ecto.NoResultsError` if the <%= schema.human_singular %> does not exist.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= action %>!("38cd0012-79dc-4838-acc0-94d4143c4f2c")
      %<%= inspect schema.alias %>{}

      iex> <%= schema.human_singular %>API.<%= action %>!("815af9955-19ab-2567-bdd1-49e4143c4g3d")
      ** (Ecto.NoResultsError)

  """
  def <%= action %>!(uuid) when is_binary(uuid), do: <%= module_action_name %>.<%= action_first_word %>!(uuid)
