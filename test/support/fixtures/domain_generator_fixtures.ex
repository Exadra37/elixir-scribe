defmodule ElixirScribe.Generator.DomainFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirScribe.Generator.Domain` context.
  """

  alias ElixirScribe.Generator.Domain.ResourceAPI
  alias ElixirScribe.Generator.Domain.Resource.BuildContext.BuildContextResource

  @default_args ["Site.Blog", "Post", "posts", "name:string", "desc:string"]
  def context_fixture(args \\ @default_args) do
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    BuildContextResource.build!(valid_args, opts, __MODULE__)
  end
end
