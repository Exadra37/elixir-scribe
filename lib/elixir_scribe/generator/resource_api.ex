defmodule ElixirScribe.Generator.Domain.ResourceAPI do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Generator.Domain.Resource.BuildContext.BuildContextResource
  alias ElixirScribe.Generator.Domain.Resource.BuildFilesToGenerate.BuildFilesToGenerateResource
  alias ElixirScribe.Generator.Domain.Resource.BuildAPIFilePaths.BuildAPIFilePathsResource
  alias ElixirScribe.Generator.Domain.Resource.GenerateActions.GenerateActionsResource
  alias ElixirScribe.Generator.Domain.Resource.GenerateTests.GenerateTestsResource
  alias ElixirScribe.Generator.Domain.Resource.BuildActionFilesPaths.BuildActionFilesPathsResource
  alias ElixirScribe.Generator.Domain.Resource.BuildTestActionFilesPaths.BuildTestActionFilesPathsResource
  alias ElixirScribe.Generator.Domain.Resource.GenerateApi.GenerateApiResource
  alias ElixirScribe.Generator.Domain.Resource.GenerateTestFixture.GenerateTestFixtureResource
  alias ElixirScribe.Generator.Domain.Resource.GenerateNewFiles.GenerateNewFilesResource
  alias ElixirScribe.Mix.Arg.ParseAll.ParseAllArgs

  @doc """
  Resource: Parse Args.
  """
  def parse_args(args) when is_list(args), do: ParseAllArgs.parse(args)

  @doc """
  Resource: Build DomainContract.
  """
  def build_context!(args, opts) when is_list(args) and is_list(opts),
    do: BuildContextResource.build!(args, opts)

  @doc """
  Resource: Files To Generate.
  """
  def build_files_to_generate(%DomainContract{} = context), do: BuildFilesToGenerateResource.build(context)

  @doc """
  Resource: Build Action Files To Generate
  """
  def build_action_files_paths(%DomainContract{} = context), do: BuildActionFilesPathsResource.build(context)

  @doc """
  Resource: Build Test Action Files To Generate
  """
  def build_test_action_files_paths(%DomainContract{} = context), do: BuildTestActionFilesPathsResource.build(context)

  def build_api_file_paths(%DomainContract{} = context), do: BuildAPIFilePathsResource.build(context)

  @doc """
  Resource: Generate Actions.
  """
  def generate_actions(%DomainContract{} = context),
    do: GenerateActionsResource.generate(context)

  @doc """
  Resource: Generate Tests.
  """
  def generate_tests(%DomainContract{} = context),
    do: GenerateTestsResource.generate_tests(context)

  @doc """
  Resource: Generate Api.
  """
  def generate_api(%DomainContract{} = context), do: GenerateApiResource.generate(context)

  @doc """
  Resource: Generate Test Fixture.
  """
  def generate_test_fixture(%DomainContract{} = context),
    do: GenerateTestFixtureResource.generate(context)

  @doc """
  Resource: Generate New Files.
  """
  def generate_new_files(%DomainContract{} = context, opts \\ []) when is_list(opts),
    do: GenerateNewFilesResource.generate(context)
end
