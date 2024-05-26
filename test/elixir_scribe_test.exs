defmodule ElixirScribeTest do
  use ExUnit.Case
  doctest ElixirScribe

  alias ElixirScribe.DomainGenerator.ResourceAPI
  alias ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResource

  @default_args ["Site.Blog", "Post", "posts", "name:string", "desc:string"]
  defp fixture(:context, args \\ @default_args) do
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    BuildContextResource.build!(valid_args, opts, __MODULE__)
  end

  describe "get_app_name/1" do
    test "return the app name as a string" do
      assert ElixirScribe.get_app_name() === "elixir_scribe"
    end
  end

  describe "get_app_path/1" do
    test "returns app core path" do
      assert ElixirScribe.get_app_path(:lib_core) === "lib/elixir_scribe"
    end

    test "returns app web path" do
      assert ElixirScribe.get_app_path(:lib_web) === "lib/elixir_scribe_web"
    end
  end

  describe "get_domain_path/2" do
    test "returns domain path for :lib_core" do
      context = fixture(:context)

      assert ElixirScribe.get_domain_path(context, :lib_core) === "lib/elixir_scribe/domain/site/blog"
    end

    test "returns domain path for :lib_web" do
      context = fixture(:context)

      assert ElixirScribe.get_domain_path(context, :lib_web) === "lib/elixir_scribe_web/domain/site/blog"
    end

    test "returns domain path for :test_core" do
      context = fixture(:context)

      assert ElixirScribe.get_domain_path(context, :test_core) === "test/elixir_scribe/domain/site/blog"
    end

    test "returns domain path for :test_web" do
      context = fixture(:context)

      assert ElixirScribe.get_domain_path(context, :test_web) === "test/elixir_scribe_web/domain/site/blog"
    end
  end

  describe "get_resource_path/2" do
    test "returns resource path for :lib_core" do
      context = fixture(:context)

      assert ElixirScribe.get_resource_path(context, :lib_core) === "lib/elixir_scribe/domain/site/blog/post"
    end

    test "returns resource path for :lib_web" do
      context = fixture(:context)

      assert ElixirScribe.get_resource_path(context, :lib_web) === "lib/elixir_scribe_web/domain/site/blog/post"
    end

    test "returns resource path for :test_core" do
      context = fixture(:context)

      assert ElixirScribe.get_resource_path(context, :test_core) === "test/elixir_scribe/domain/site/blog/post"
    end

    test "returns resource path for :test_web" do
      context = fixture(:context)

      assert ElixirScribe.get_resource_path(context, :test_web) === "test/elixir_scribe_web/domain/site/blog/post"
    end
  end

end
