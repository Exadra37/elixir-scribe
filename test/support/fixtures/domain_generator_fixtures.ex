defmodule ElixirScribe.DomainGeneratorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirScribe.DomainGenerator` context.
  """

  alias ElixirScribe.MixGenerator.AppAPIContract.BuildDomainPathContract
  alias ElixirScribe.MixGenerator.AppAPIContract.BuildResourcePathContract
  alias ElixirScribe.DomainGenerator.ResourceAPI
  alias ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResource


  @default_args ["Site.Blog", "Post", "posts", "name:string", "desc:string"]
  def context_fixture(args \\ @default_args) do
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    BuildContextResource.build!(valid_args, opts, __MODULE__)
  end

  def domain_path_contract_fixture(attrs \\ %{}) do
   %{
      app_lib_dir: context_fixture().dir,
      path_type: :lib_core
    }
    |> Map.merge(attrs)
    |> BuildDomainPathContract.new!()
  end

  def resource_path_contract_fixture(attrs) do
   %{
      domain_contract: domain_path_contract_fixture(),
      singular_name: "post"
    }
    |> Map.merge(attrs)
    |> BuildResourcePathContract.new!()
  end
end
