defmodule ElixirScribe.Generator.Domain.ResourceAPI do
  @moduledoc false

  alias Mix.Scribe.Context
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
  Resource: Build Context.
  """
  def build_context!(args, opts, help) when is_list(args) and is_list(opts),
    do: BuildContextResource.build!(args, opts, help)

  @doc """
  Resource: Files To Generate.
  """
  def build_files_to_generate(%Context{} = context), do: BuildFilesToGenerateResource.build(context)

  @doc """
  Resource: Build Action Files To Generate
  """
  def build_action_files_paths(%Context{} = context), do: BuildActionFilesPathsResource.build(context)

  @doc """
  Resource: Build Test Action Files To Generate
  """
  def build_test_action_files_paths(%Context{} = context), do: BuildTestActionFilesPathsResource.build(context)

  def build_api_file_paths(%Context{} = context), do: BuildAPIFilePathsResource.build(context)

  @doc """
  Resource: Generate Actions.
  """
  def generate_actions(%Context{} = context),
    do: GenerateActionsResource.generate(context)

  @doc """
  Resource: Generate Tests.
  """
  def generate_tests(%Context{} = context),
    do: GenerateTestsResource.generate_tests(context)

  @doc """
  Resource: Generate Api.
  """
  def generate_api(%Context{} = context), do: GenerateApiResource.generate(context)

  @doc """
  Resource: Generate Test Fixture.
  """
  def generate_test_fixture(%Context{} = context),
    do: GenerateTestFixtureResource.generate(context)

  @doc """
  Resource: Generate New Files.
  """
  def generate_new_files(%Context{} = context, opts \\ []) when is_list(opts),
    do: GenerateNewFilesResource.generate(context)
end
