
  @doc """
  Returns the list of <%= schema.plural %>.

  ## Examples

      iex> <%= action %>_<%= schema.plural %>()
      [%<%= inspect schema.alias %>{}, ...]

  """
  def <%= action %>_<%= schema.plural %>, do: <%= action_capitalized %><%= schema.human_plural %>.<%= action_first_word %>()
