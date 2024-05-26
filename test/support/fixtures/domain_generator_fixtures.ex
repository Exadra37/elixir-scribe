defmodule ElixirScribe.DomainGeneratorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirScribe.DomainGenerator` context.
  """

  alias ElixirScribe.DomainGenerator.ResourceAPI
  alias ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResource

  @doc """
  Generate a resource.
  """
  def resource_fixture(attrs \\ %{}) do
    {:ok, resource} =
      attrs
      |> Enum.into(%{})
      |> ResourceAPI.create_resource()

    resource
  end
end
