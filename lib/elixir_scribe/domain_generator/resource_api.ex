defmodule ElixirScribe.DomainGenerator.ResourceAPI do
  @moduledoc false

  alias Mix.Scribe.Context
  alias Mix.Scribe.Schema
  alias ElixirScribe.DomainGenerator.Resource.GenerateActions.GenerateActionsResource
  alias ElixirScribe.DomainGenerator.Resource.GenerateTests.GenerateTestsResource
  alias ElixirScribe.DomainGenerator.Resource.PromptForConflicts.PromptForConflictsResource
  alias ElixirScribe.DomainGenerator.Resource.FilesToGenerate.FilesToGenerateResource
  alias ElixirScribe.DomainGenerator.Resource.GenerateApi.GenerateApiResource
  alias ElixirScribe.DomainGenerator.Resource.GenerateTestFixture.GenerateTestFixtureResource
  alias ElixirScribe.DomainGenerator.Resource.GenerateNewFiles.GenerateNewFilesResource
  alias ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResource
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
  Resource: Generate Actions.
  """
  def generate_actions(%Context{} = context, paths),
    do: GenerateActionsResource.generate(context, paths)

  @doc """
  Resource: Generate Tests.
  """
  def generate_tests(%Context{} = context, paths),
    do: GenerateTestsResource.generate_tests(context, paths)

  @doc """
  Resource: Prompt For Conflicts.
  """
  def prompt_for_conflicts(%Schema{} = context), do: PromptForConflictsResource.prompt(context)

  @doc """
  Resource: Files To Generate.
  """
  def files_to_generate(%Context{} = context), do: FilesToGenerateResource.files(context)

  @doc """
  Resource: Generate Api.
  """
  def generate_api(%Context{} = context, paths), do: GenerateApiResource.generate(context, paths)

  @doc """
  Resource: Generate Test Fixture.
  """
  def generate_test_fixture(%Context{} = context, paths),
    do: GenerateTestFixtureResource.generate(context, paths)

  @doc """
  Resource: Generate New Files.
  """
  def generate_new_files(%Context{} = context, opts \\ []) when is_list(opts),
    do: GenerateNewFilesResource.generate(context)
end
