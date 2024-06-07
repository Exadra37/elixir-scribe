defmodule ElixirScribe.MixGenerator.App.BuildResourceActionFilePath.BuildResourceActionFilePathAppTest do
  use ExUnit.Case, async: true

  import ElixirScribe.DomainGeneratorFixtures

  alias ElixirScribe.MixGenerator.AppAPI
  alias ElixirScribe.MixGenerator.AppAPIContract.BuildResourceActionFilePathContract

  @default_attrs %{
    context: context_fixture(),
    action: "create",
    file_extension: ".ex",
    file_type_prefix: "",
    file_type: "",
    path_type: :lib_core
  }

  setup test_context do
    attrs = Map.merge(@default_attrs, test_context)
    contract = BuildResourceActionFilePathContract.new!(attrs)

    %{contract: contract}
  end

  describe "build_resource_action_file_path/1 for lib folder" do
    test "returns the resource action file path for :lib_core", %{contract: contract} do

      assert AppAPI.build_resource_action_file_path(contract) === "lib/elixir_scribe/domain/site/blog/post/create/create_post.ex"
    end

    @tag path_type: :lib_web
    test "returns the resource action file path for :lib_web", %{contract: contract} do

      assert AppAPI.build_resource_action_file_path(contract) === "lib/elixir_scribe_web/domain/site/blog/post/create/create_post.ex"
    end
  end

  describe "build_resource_action_file_path/1 for test folder" do
    @tag path_type: :test_core, file_type_prefix: "_", file_type: "test", file_extension: ".exs"
    test "returns the resource action test file path for :test_core", %{contract: contract} do

      assert AppAPI.build_resource_action_file_path(contract) === "test/elixir_scribe/domain/site/blog/post/create/create_post_test.exs"
    end

    @tag path_type: :test_web, file_type_prefix: "_", file_type: "test", file_extension: ".exs"
    test "returns the resource action test file path for :test_web", %{contract: contract} do

      assert AppAPI.build_resource_action_file_path(contract) === "test/elixir_scribe_web/domain/site/blog/post/create/create_post_test.exs"
    end
  end
end
