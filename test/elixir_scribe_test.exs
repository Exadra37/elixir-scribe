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

  describe "base_template_paths/0" do
    test "returns a list of base paths in the expected order" do
      assert ElixirScribe.base_template_paths() === [".", :elixir_scribe, :phoenix]
    end
  end

  describe "web_template_path/0" do
    test "returns the web template path" do
      assert ElixirScribe.web_template_path() === "priv/templates/scribe.gen.html"
    end
  end

  describe "html_template_path/0" do
    test "returns the html template path" do
      assert ElixirScribe.html_template_path() === "priv/templates/scribe.gen.html/html"
    end
  end

  describe "controller_template_path/0" do
    test "returns the controller template path" do
      assert ElixirScribe.controller_template_path() === "priv/templates/scribe.gen.html/controllers"
    end
  end

  describe "controller_test_template_path/0" do
    test "returns the controller test template path" do
      assert ElixirScribe.controller_test_template_path() === "priv/templates/scribe.gen.html/tests/controllers"
    end
  end

  describe "domain_template_path/0" do
    test "returns the domain template path" do
      assert ElixirScribe.domain_template_path() === "priv/templates/scribe.gen.domain"
    end
  end

  describe "domain_tests_template_path/0" do
    test "returns the default domain tests template path" do
      assert ElixirScribe.domain_tests_template_path() === "priv/templates/scribe.gen.domain/tests"
    end
  end

  describe "domain_api_template_path/0" do
    test "returns the default domain api template path" do
      assert ElixirScribe.domain_api_template_path() === "priv/templates/scribe.gen.domain/apis"
    end
  end

  describe "resource_actions_template_path/0" do
    test "returns the default domain actions template path" do
      assert ElixirScribe.resource_actions_template_path() === "priv/templates/scribe.gen.domain/actions"
    end
  end

  describe "resource_actions/0" do
    test "returns the default resource actions in the expected order" do
      assert ElixirScribe.resource_actions() === ["list", "new", "read", "edit", "create", "update", "delete"]
    end
  end

  describe "resource_actions_aliases/0" do
    test "returns an empty map when no aliases are configure in the app config" do
      assert ElixirScribe.resource_actions_aliases() === %{}
    end

    # test "returns the default resource actions aliases as per app configuration" do
    #   assert ElixirScribe.resource_actions_aliases() === %{}
    # end
  end

  describe "resource_action_alias/1" do
    test "returns the same action when no alias is configured for action in the app config" do
      assert ElixirScribe.resource_action_alias("create") === "create"
    end
  end


  describe "app_name/0" do
    test "return the app name as a string" do
      assert ElixirScribe.app_name() === "elixir_scribe"
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

  describe "get_schema_file_path/1" do
    test "returns schema file path" do
      context = fixture(:context)

      assert ElixirScribe.get_schema_file_path(context) === "lib/elixir_scribe/domain/site/blog/post_schema.ex"
    end
  end

  describe "build_resource_action_file_path/4" do
    test "returns the resource action file path for :lib_core" do
      context = fixture(:context)
      action = "create"
      suffix = ".ex"
      type = :lib_core

      assert ElixirScribe.build_resource_action_file_path(context, action, suffix, type) === "lib/elixir_scribe/domain/site/blog/post/create/create_post.ex"
    end

    test "returns the resource action file path for :lib_web" do
      context = fixture(:context)
      action = "create"
      suffix = ".ex"
      type = :lib_web

      assert ElixirScribe.build_resource_action_file_path(context, action, suffix, type) === "lib/elixir_scribe_web/domain/site/blog/post/create/create_post.ex"
    end

    test "returns the resource action file path for :test_core" do
      context = fixture(:context)
      action = "create"
      suffix = ".ex"
      type = :test_core

      assert ElixirScribe.build_resource_action_file_path(context, action, suffix, type) === "test/elixir_scribe/domain/site/blog/post/create/create_post.ex"
    end

    test "returns the resource action file path for :test_web" do
      context = fixture(:context)
      action = "create"
      suffix = ".ex"
      type = :test_web

      assert ElixirScribe.build_resource_action_file_path(context, action, suffix, type) === "test/elixir_scribe_web/domain/site/blog/post/create/create_post.ex"
    end
  end

end
