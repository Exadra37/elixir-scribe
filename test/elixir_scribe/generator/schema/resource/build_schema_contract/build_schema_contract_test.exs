defmodule ElixirScribe.Generator.Schema.Resource.BuildSchemaResourceContractTest do
alias ElixirScribe.Generator.Schema.Resource.BuildSchemaResourceContract

  use ElixirScribe.BaseCase, async: true

  describe "Doesn't build the Schema contract" do
    test "when is missing some of the required args" do
      args = ["Blog.Site.Admin", "Post"]
      opts = []

      assert_raise RuntimeError, ~r/^Not enough arguments.*$/s, fn ->
        BuildSchemaResourceContract.build!(args, opts)
      end
    end

    test "when is missing all the required args" do
      args = []
      opts = []

      assert_raise RuntimeError, ~r/^No arguments were provided.*$/s, fn ->
        BuildSchemaResourceContract.build!(args, opts)
      end
    end

    test "when the Domain isn't a valid module name" do
      args = ["Blog.Site.admin", "Post", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Expected the Domain, \"Blog.Site.admin\", to be a valid module name.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the Resource isn't a valid module name" do
      args = ["Blog.Admin", "post", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Expected the Resource, \"post\", to be a valid module name.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the Domain and Resource have the same name" do
      args = ["Blog", "Blog", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^The Domain and Resource should have different name.*$/s,
                   fn ->
                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when the Domain and the Application have the same name" do
      args = ["ElixirScribe", "Blog", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Cannot generate Domain ElixirScribe because it has the same name as the application.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the Resource and the Application have the same name" do
      args = ["Blog", "ElixirScribe", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Cannot generate Resource ElixirScribe because it has the same name as the application.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "table name missing from references", config do
        assert_raise Mix.Error, ~r/expect the table to be given to user_id:references/, fn ->
          args = ["Blog.Post", "posts", "user_id:references"]
          opts = []

          BuildSchemaResourceContract.build!(args, opts)
        end
      end
  end
end
