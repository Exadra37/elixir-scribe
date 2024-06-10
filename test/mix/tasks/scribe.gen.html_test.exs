defmodule Mix.Tasks.Scribe.Gen.HtmlTest do
  use ExUnit.Case

  require Assertions

  alias Mix.Tasks.Scribe.Gen.Html
  alias ElixirScribe.DomainGenerator.ResourceAPI
  alias ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResource

  @default_args ["Site.Blog", "Post", "posts", "name:string", "desc:string"]
  defp fixture(:context, args \\ @default_args) do
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    BuildContextResource.build!(valid_args, opts, __MODULE__)
  end

  describe "files_to_be_generated/1" do
    test "returns files for core, web and releated tests" do
      context = fixture(:context)

      resource_actions = ElixirScribe.resource_actions()

      expected_files = [
        {:eex, "priv/templates/scribe.gen.html/html/default/resource_form.html.heex", "lib/elixir_scribe_web/domain/site/blog/post/post_form.html.heex", ""},
        {:eex, "priv/templates/scribe.gen.html/html/default/html.ex", "lib/elixir_scribe_web/domain/site/blog/post/post_html.ex", ""}
      ]

      expected_files =
        for action <- resource_actions, reduce: expected_files do
          expected_files ->
            resource = (action in ElixirScribe.resource_plural_actions()) && "posts" || "post"
            source = "priv/templates/scribe.gen.html/controllers/#{action}_controller.ex"
            target = "lib/elixir_scribe_web/domain/site/blog/post/#{action}/#{action}_#{resource}_controller.ex"

            controller_test_file = {:eex, source, target, action}

            [controller_test_file | expected_files]
        end

      html_actions = ElixirScribe.resource_html_actions()

      expected_files =
        for html_action <- html_actions, reduce: expected_files do
          expected_files ->
            resource = (html_action in ElixirScribe.resource_plural_actions()) && "posts" || "post"
            source = "priv/templates/scribe.gen.html/html/default/#{html_action}.html.heex"
            target =
              "lib/elixir_scribe_web/domain/site/blog/post/#{html_action}/#{html_action}_#{resource}.html.heex"

            file = {:eex, source, target, html_action}
            [file | expected_files]
        end

      expected_files =
        for action <- resource_actions, reduce: expected_files do
          expected_files ->
            resource = (action in ElixirScribe.resource_plural_actions()) && "posts" || "post"
            source_test =
              "priv/templates/scribe.gen.html/tests/controllers/#{action}_controller_test.exs"
            target_test =
              "test/elixir_scribe_web/domain/site/blog/post/#{action}/#{action}_#{resource}_controller_test.exs"

            controller_test_file = {:eex, source_test, target_test, action}

            [controller_test_file | expected_files]
        end

      files = Html.files_to_be_generated(context)

      assert length(files) === length(expected_files)
      Assertions.assert_lists_equal(expected_files, files)
    end
  end
end
