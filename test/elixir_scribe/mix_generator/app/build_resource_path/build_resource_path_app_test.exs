defmodule ElixirScribe.MixGenerator.App.BuildResourcePath.BuildResourcePathAppTest do
  use ExUnit.Case, async: true

  import ElixirScribe.DomainGeneratorFixtures

  alias ElixirScribe.MixGenerator.AppAPI
  alias  ElixirScribe.MixGenerator.AppAPIContract.BuildDomainPathContract

  setup test_context do
    %{contract: resource_path_contract_fixture(test_context)}
  end

  describe "build_resource_path/1 for lib folder" do
    test "returns resource path for :lib_core", %{contract: contract} do
      assert  AppAPI.build_domain_path(contract) === "lib/elixir_scribe/domain/site/blog/post"
    end

    test "returns resource path for :lib_web", %{contract: contract} do
      assert  AppAPI.build_domain_path(contract) === "lib/elixir_scribe_web/domain/site/blog/post"
    end
  end

  describe "build_resource_path for test folder" do
    test "returns resource path for :test_core", %{contract: contract} do
      assert  AppAPI.build_domain_path(contract) === "test/elixir_scribe/domain/site/blog/post"
    end

    test "returns resource path for :test_web", %{contract: contract} do
      assert  AppAPI.build_domain_path(contract) === "test/elixir_scribe_web/domain/site/blog/post"
    end
  end

end
