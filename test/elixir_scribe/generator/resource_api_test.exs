Code.require_file("../../mix_test_helper.exs", __DIR__)

defmodule ElixirScribe.Generator.Domain.ResourceAPITest do
  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.Generator.Domain.ResourceAPI
  use ElixirScribe.BaseCase, async: true

  import MixTestHelper

  # INFO: Tests in the API module only care about testing the function can be invoked and that the API contract is respected (for now only guards and pattern matching). The unit tests for the functionality are done in their respective modules

  describe "parse_args/1" do
    test "can be invoked" do
      assert {_parsed_args, _opts, _invalid_args} = MixAPI.parse_cli_command([])
    end

    test "raises a FunctionClauseError when the argument isn't a list" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        MixAPI.parse_cli_command(%{})
      end
    end
  end

  describe "build_domain_resource_contract/2" do
    test "can be invoked" do
      args = ["Blog", "Post", "posts", "title:string", "desc:string"]
      {valid_args, opts, _invalid_args} = args |> MixAPI.parse_cli_command()

      assert {:ok, %DomainContract{}} = ResourceAPI.build_domain_resource_contract(valid_args, opts)
    end

    test "raises FunctionClausedError when arguments aren't a list" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ResourceAPI.build_domain_resource_contract(%{}, %{})
      end
    end
  end

  describe "build_files_to_generate/1" do
    test "can be invoked" do
      domain_contract = domain_contract_fixture()

      assert ResourceAPI.build_files_to_generate(domain_contract) |> is_list()
    end

    test "raises FunctionClausedError when the argument isn't a %DomainContract{}" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ResourceAPI.build_files_to_generate(%{})
      end
    end
  end

  describe "build_action_files_paths/1" do
    test "can be invoked" do
      domain_contract = domain_contract_fixture()

      assert ResourceAPI.build_action_files_paths(domain_contract) |> is_list()
    end

    test "raises FunctionClausedError when the argument isn't a %DomainContract{}" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ResourceAPI.build_action_files_paths(%{})
      end
    end
  end

  describe "build_test_action_files_paths/1" do
    test "can be invoked" do
      domain_contract = domain_contract_fixture()

      assert ResourceAPI.build_test_action_files_paths(domain_contract) |> is_list()
    end

    test "raises FunctionClausedError when the argument isn't a %DomainContract{}" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ResourceAPI.build_test_action_files_paths(%{})
      end
    end
  end

  describe "generate_actions/1" do
    setup do
      Mix.Task.clear()
      :ok
    end

    test "can be invoked", config do
      in_tmp_project(config.test, fn ->
        domain_contract = domain_contract_fixture()

        assert %DomainContract{} = ResourceAPI.generate_actions(domain_contract)
      end)
    end

    test "raises FunctionClausedError when the argument isn't a %DomainContract{}" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ResourceAPI.generate_actions(%{})
      end
    end
  end

  describe "generate_tests/1" do
    setup do
      Mix.Task.clear()
      :ok
    end

    test "can be invoked", config do
      in_tmp_project(config.test, fn ->
        domain_contract = domain_contract_fixture()

        assert %DomainContract{} = ResourceAPI.generate_tests(domain_contract)
      end)
    end

    test "raises FunctionClausedError when the argument isn't a %DomainContract{}" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ResourceAPI.generate_tests(%{})
      end
    end
  end

  describe "generate_api/1" do
    setup do
      Mix.Task.clear()
      :ok
    end

    test "can be invoked", config do
      in_tmp_project(config.test, fn ->
        domain_contract = domain_contract_fixture()

        assert %DomainContract{} = ResourceAPI.generate_api(domain_contract)
      end)
    end

    test "raises FunctionClausedError when the argument isn't a %DomainContract{}" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ResourceAPI.generate_api(%{})
      end
    end
  end

  describe "generate_test_fixture/1" do
    setup do
      Mix.Task.clear()
      :ok
    end

    test "can be invoked", config do
      in_tmp_project(config.test, fn ->
        domain_contract = domain_contract_fixture()

        assert %DomainContract{} = ResourceAPI.generate_test_fixture(domain_contract)
      end)
    end

    test "raises FunctionClausedError when the argument isn't a %DomainContract{}" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ResourceAPI.generate_test_fixture(%{})
      end
    end
  end

  describe "generate_new_files/1" do
    setup do
      Mix.Task.clear()
      :ok
    end

    test "can be invoked", config do
      in_tmp_project(config.test, fn ->
        domain_contract = domain_contract_fixture()

        assert %DomainContract{} = ResourceAPI.generate_new_files(domain_contract)
      end)
    end

    test "raises FunctionClausedError when the argument isn't a %DomainContract{}" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ResourceAPI.generate_new_files(%{})
      end
    end
  end
end
