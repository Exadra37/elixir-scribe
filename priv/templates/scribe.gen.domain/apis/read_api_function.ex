
  @doc """
  Gets the <%= schema.singular %> for the given `id`.

  Raises `Ecto.NoResultsError` if the <%= schema.human_singular %> does not exist.

  ## Examples

      iex> <%= action %>_<%= schema.singular %>!(123)
      %<%= inspect schema.alias %>{}

      iex> <%= action %>_<%= schema.singular %>!(456)
      ** (Ecto.NoResultsError)

  """
  def <%= action %>_<%= schema.singular %>!(id), do: <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>!(id)
