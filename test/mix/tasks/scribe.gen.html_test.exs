defmodule Mix.Tasks.Scribe.Gen.HtmlTest do
  use ExUnit.Case

  require Assertions

  alias Mix.Tasks.Scribe.Gen.Html
  alias ElixirScribe.Generator.Domain.ResourceAPI
  alias ElixirScribe.Generator.Domain.Resource.BuildContext.BuildContextResource

  @default_args ["Site.Blog", "Post", "posts", "name:string", "desc:string"]
  defp fixture(:context, args \\ @default_args) do
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    BuildContextResource.build!(valid_args, opts, __MODULE__)
  end

  describe "files_to_be_generated/1" do
    test "returns files for core, web and related tests" do
      context = fixture(:context)

      expected_files = [
        {:eex, :html, "priv/templates/scribe.gen.html/html/default/list.html.heex",
         "lib/elixir_scribe_web/domain/site/blog/post/list/list_posts.html.heex", "list"},
        {:eex, :html, "priv/templates/scribe.gen.html/html/default/edit.html.heex",
         "lib/elixir_scribe_web/domain/site/blog/post/edit/edit_post.html.heex", "edit"},
        {:eex, :html, "priv/templates/scribe.gen.html/html/default/new.html.heex",
         "lib/elixir_scribe_web/domain/site/blog/post/new/new_post.html.heex", "new"},
        {:eex, :html, "priv/templates/scribe.gen.html/html/default/read.html.heex",
         "lib/elixir_scribe_web/domain/site/blog/post/read/read_post.html.heex", "read"},
        {:eex, :controller_test,
         "priv/templates/scribe.gen.html/tests/controllers/delete_controller_test.exs",
         "test/elixir_scribe_web/domain/site/blog/post/delete/delete_post_controller_test.exs",
         "delete"},
        {:eex, :controller_test,
         "priv/templates/scribe.gen.html/tests/controllers/update_controller_test.exs",
         "test/elixir_scribe_web/domain/site/blog/post/update/update_post_controller_test.exs",
         "update"},
        {:eex, :controller_test,
         "priv/templates/scribe.gen.html/tests/controllers/create_controller_test.exs",
         "test/elixir_scribe_web/domain/site/blog/post/create/create_post_controller_test.exs",
         "create"},
        {:eex, :controller_test,
         "priv/templates/scribe.gen.html/tests/controllers/edit_controller_test.exs",
         "test/elixir_scribe_web/domain/site/blog/post/edit/edit_post_controller_test.exs",
         "edit"},
        {:eex, :controller_test,
         "priv/templates/scribe.gen.html/tests/controllers/read_controller_test.exs",
         "test/elixir_scribe_web/domain/site/blog/post/read/read_post_controller_test.exs",
         "read"},
        {:eex, :controller_test,
         "priv/templates/scribe.gen.html/tests/controllers/new_controller_test.exs",
         "test/elixir_scribe_web/domain/site/blog/post/new/new_post_controller_test.exs", "new"},
        {:eex, :controller_test,
         "priv/templates/scribe.gen.html/tests/controllers/list_controller_test.exs",
         "test/elixir_scribe_web/domain/site/blog/post/list/list_posts_controller_test.exs",
         "list"},
        {:eex, :controller, "priv/templates/scribe.gen.html/controllers/delete_controller.ex",
         "lib/elixir_scribe_web/domain/site/blog/post/delete/delete_post_controller.ex",
         "delete"},
        {:eex, :controller, "priv/templates/scribe.gen.html/controllers/update_controller.ex",
         "lib/elixir_scribe_web/domain/site/blog/post/update/update_post_controller.ex",
         "update"},
        {:eex, :controller, "priv/templates/scribe.gen.html/controllers/create_controller.ex",
         "lib/elixir_scribe_web/domain/site/blog/post/create/create_post_controller.ex",
         "create"},
        {:eex, :controller, "priv/templates/scribe.gen.html/controllers/edit_controller.ex",
         "lib/elixir_scribe_web/domain/site/blog/post/edit/edit_post_controller.ex", "edit"},
        {:eex, :controller, "priv/templates/scribe.gen.html/controllers/read_controller.ex",
         "lib/elixir_scribe_web/domain/site/blog/post/read/read_post_controller.ex", "read"},
        {:eex, :controller, "priv/templates/scribe.gen.html/controllers/new_controller.ex",
         "lib/elixir_scribe_web/domain/site/blog/post/new/new_post_controller.ex", "new"},
        {:eex, :controller, "priv/templates/scribe.gen.html/controllers/list_controller.ex",
         "lib/elixir_scribe_web/domain/site/blog/post/list/list_posts_controller.ex", "list"},
        {:eex, :html, "priv/templates/scribe.gen.html/html/default/resource_form.html.heex",
         "lib/elixir_scribe_web/domain/site/blog/post/post_form.html.heex", ""},
        {:eex, :html, "priv/templates/scribe.gen.html/html/default/html.ex",
         "lib/elixir_scribe_web/domain/site/blog/post/post_html.ex", ""}
      ]

      files = Html.files_to_be_generated(context)

      assert length(files) === length(expected_files)
      Assertions.assert_lists_equal(expected_files, files)
    end
  end
end
