defmodule ElixirScribe.DomainGenerator.ResourceAPI do
  @moduledoc false

  alias Mix.Scribe.Context
  alias Mix.Scribe.Schema

  alias ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResource
  alias ElixirScribe.DomainGenerator.Resource.BuildAPIFilePaths.BuildAPIFilePathsResource
  alias ElixirScribe.DomainGenerator.Resource.GenerateActions.GenerateActionsResource
  alias ElixirScribe.DomainGenerator.Resource.GenerateTests.GenerateTestsResource
  alias ElixirScribe.DomainGenerator.Resource.PromptForConflicts.PromptForConflictsResource
  alias ElixirScribe.DomainGenerator.Resource.BuildActionFilesPaths.BuildActionFilesPathsResource
  alias ElixirScribe.DomainGenerator.Resource.GenerateApi.GenerateApiResource
  alias ElixirScribe.DomainGenerator.Resource.GenerateTestFixture.GenerateTestFixtureResource
  alias ElixirScribe.DomainGenerator.Resource.GenerateNewFiles.GenerateNewFilesResource
  alias ElixirScribe.DomainGenerator.Resource.ParseArgs.ParseArgsResource

  @doc """
  Resource: Parse Args.
  """
  def parse_args(args) when is_list(args), do: ParseArgsResource.parse(args)

  @doc """
  Resource: Build Context.
  """
  def build_context!(args, opts, help) when is_list(args) and is_list(opts),
    do: BuildContextResource.build!(args, opts, help)

  @doc """
  Resource: Files To Generate.
  """
  def build_action_files_paths(%Context{} = context), do: BuildActionFilesPathsResource.build(context)

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
  Resource: Prompt For Conflicts.
  """
  def prompt_for_conflicts(%Schema{} = context), do: PromptForConflictsResource.prompt(context)

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
