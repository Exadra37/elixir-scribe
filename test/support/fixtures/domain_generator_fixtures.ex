defmodule ElixirScribe.DomainGeneratorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirScribe.DomainGenerator` context.
  """

  alias ElixirScribe.DomainGenerator.ResourceAPI
  alias ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResource

  @default_args ["Site.Blog", "Post", "posts", "name:string", "desc:string"]
  def context_fixture(args \\ @default_args) do
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    BuildContextResource.build!(valid_args, opts, __MODULE__)
  end
end
