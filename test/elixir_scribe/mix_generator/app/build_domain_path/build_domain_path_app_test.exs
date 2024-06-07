defmodule ElixirScribe.MixGenerator.App.BuildDomainPath.BuildDomainPathAppTest do
  use ExUnit.Case, async: true

  import ElixirScribe.DomainGeneratorFixtures

  alias ElixirScribe.MixGenerator.AppAPI
  alias  ElixirScribe.MixGenerator.AppAPIContract.BuildDomainPathContract

  setup test_context do
    %{contract: domain_path_contract_fixture(test_context)}
  end

  describe "build_domain_path/1 for lib folder" do
    test "returns the domain path for :lib_core", %{contract: contract} do

      assert AppAPI.build_domain_path(contract) === "lib/elixir_scribe/domain/site/blog"
    end

    @tag path_type: :lib_web
    test "returns the domain path for :lib_web", %{contract: contract} do

      assert AppAPI.build_domain_path(contract) === "lib/elixir_scribe_web/domain/site/blog"
    end
  end

  describe "build_domain_path/1 for test folder" do
    @tag path_type: :test_core
    test "returns the domain path for :test_core", %{contract: contract} do

      assert AppAPI.build_domain_path(contract) === "test/elixir_scribe/domain/site/blog"
    end

    @tag path_type: :test_web
    test "returns the domain path for :test_web", %{contract: contract} do

      assert AppAPI.build_domain_path(contract) === "test/elixir_scribe_web/domain/site/blog"
    end
  end
end
