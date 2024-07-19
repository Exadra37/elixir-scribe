defmodule ElixirScribe.Generator.Domain.Resource.BuildContract.BuildDomainResourceContract do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.DomainContract

  @doc false
  def build(args, opts) when is_list(args) and is_list(opts), do: DomainContract.new(args, opts)

  def build!(args, opts) when is_list(args) and is_list(opts), do: DomainContract.new!(args, opts)

end
