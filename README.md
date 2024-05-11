# 🪶 Elixir Scribe 📜

Scribes were elites in ancient societies, highly regarded and holding special social status. They were disciplined and known for their excellent craftsmanship in writing laws, copying documents, and other related tasks.

For developers, the Scribe tool aims to help them embody the values of discipline and craftsmanship of the Scribes, enabling them to more easily write clean code in a clean software architecture for enhanced developer experience and productivity.

For businesses, the Scribe tool aims to increase velocity by enhancing developers' productivity, reducing technical debt and bugs in the codebase, while allowing features to be added more seamlessly.

Both businesses and developers will find that these benefits are visible in the short and long term, but they will appreciate them even more as more features are added and fewer bugs arise due to the overall reduced complexity when compared with less well-structured approaches. This translates into less maintenance and a more robust and easier-to-work-with codebase.

Some of the benefits of using the Scribe tool to start and maintain an Elixir or Phoenix project:

* Know all domains (contexts), resources, and actions used in your project by just looking at the folder structure.
* Newcomers to the project or anyone returning after a while can easily understand what the project is all about and quickly start working on new features or bugs (folder structure for the win).
* The single responsibility principle is encouraged by the design of the folder structure, where a clear separation of domains, resources, and actions occurs, encouraging one resource action per module.
* Helps reduce tech debt due to the separation of concerns encouraged by the folder structure.
* It's much easier to find where to add a new feature without mixing it with existing code. For example: If it's a new action on a resource, just add one more action folder and the respective module(s) inside it.
* Quickly find and start debugging a bug because actions aren't entangled in a huge module with several resources for a domain (context). For example, if the bug is about creating a resource on a given domain, it's straightforward to know where to start due to the folder structure.
* The folder structure is documentation that never lies about what domains (contexts), resources, and actions are available in your project, whether huge or small.

The Scribe tool enables developers craftsmanship and professionalism to reach new levels never imagined before or thought to not be easy to achieve.

Don't just be a Developer or Engineer, become a Scribe Developer and Engineer 🚀


## Contributing

The Elixir Scribe tool is highly opinionated, therefore I ask you to first [open a discussion](https://github.com/Exadra37/elixir-scribe/discussions/new?category=ideas) to propose your idea to avoid working and then seeing the PR refused.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_scribe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_scribe, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/elixir_scribe>.
