
  @doc """
  Gets the <%= schema.singular %> for the given `id`.

  Raises `Ecto.NoResultsError` if the <%= schema.human_singular %> does not exist.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= action %>!(123)
      %<%= inspect schema.alias %>{}

      iex> <%= schema.human_singular %>API.<%= action %>!(456)
      ** (Ecto.NoResultsError)

  """
  def <%= action %>!(id), do: <%= module_action_name %>.<%= action_first_word %>!(id)
