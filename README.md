# 🪶 Elixir Scribe 📜

Scribes were an elite in ancient societies, highly regarded and holding special social status. They were disciplined and known for their excellent craftsmanship in writing laws, copying documents, and other related tasks.

The motivation to create the Scribe tool was to encourage developers to write cleaner code in a more organized software architecture, enabling them to know in seconds all domains (contexts), resources, and actions used in a project, while reducing complexity. This reduction in complexity translates into fewer bugs and makes it easier to add new features and implement bug fixes when they arise. Consequently, this results in less maintenance and technical debt across the lifetime of a project, leading to a more robust and easier-to-work-with codebase. Ultimately, this enhances developer experience, velocity and productivity. This is a win win for both the business and developers.

The Scribe tool enables developers craftsmanship and professionalism to reach new levels never imagined before or thought to not be easy to achieve.

Don't just be a Developer or Engineer, become a Scribe Developer and Engineer 🚀


## Folder Structure

Can you grasp, in seconds, all domains, resources, and actions in your current large professional or pet projects?

With the Elixir Scribe folder structure you will always reply **YES** to the above question.

```
lib/acme_shop
├── catalog
│   ├── category
│   │   ├── assign
│   │   ├── change
│   │   ├── create
│   │   ├── delete
│   │   ├── get
│   │   ├── list
│   │   └── update
│   └── product
│       ├── assign
│       ├── change
│       ├── create
│       ├── delete
│       ├── get
│       ├── list
│       └── update
└── warehouse
    └── inventory
        ├── assign
        ├── change
        ├── create
        ├── delete
        ├── get
        ├── list
        └── update
```

> Domains: catalog, warehouse - Resources: category, product, inventory - Actions: assign, change, ...

This is a very simplistic view of a project. Now, imagine reaping the benefits of this folder structure implemented on your extensive codebase, which may now contain dozens, hundreds, or even thousands of resources, each with potentially more actions than the ones exemplified here.

Take a moment to compare and contemplate this folder structure with the traditional one used in an Elixir or Phoenix project, which often condenses several resources and all their actions into a single module (the context). Alternatively, in cases where contexts are not used, they may simply consist of large modules with only one resource and all its actions.

Can you now understand why Elixir Scribe encourages developers to write cleaner code in a more organized software architecture?


## Benefits of Using the Elixir Scribe Tool to Create and Maintain Elixir and Phoenix Projects

* Know in seconds all domains (contexts), resources, and actions used in your project by just looking at the folder structure. This is priceless for anyone working on the project.
* Newcomers to the project or anyone returning after a while can easily understand what the project is all about and quickly start working on new features or bugs (folder structure for the win).
* The single responsibility principle is encouraged by the design of the folder structure, where a clear separation of domains, resources, and actions occurs, encouraging one resource action per module.
* Helps to reduce tech debt due to the separation of concerns encouraged by the folder structure, which naturally guides developers to not mix new features into an existing module, whether it's a new domain, resource, or just an action on a resource.
* It's much easier to find where to add a new feature without mixing it with existing code. For example: If it's a new action on a resource, just add one more action folder and the respective module(s) inside it.
* Quickly find and start debugging a bug because actions aren't entangled in a huge module with several resources for a domain (context). For example, if the bug is about creating a resource on a given domain, it's straightforward to know where to start due to the folder structure.
* Each resource on a domain has a public API to avoid direct access to the underlying implementation of each resource. This removes cross-domain boundary calls into the internals of each resource implementation, preventing the coupling of domains, which is a significant source of technical debt and complexity in a codebase. The Resource public API MUST be used not only from other domains but also from within the domain itself. This will allow the internals of a resource in a domain to change as needed, provided that we do not affect the public API for it.
* The folder structure is documentation that never lies about what domains (contexts), resources, and actions are available in your project, whether huge or small.


## Installation

The [Elixir Scribe](https://hexdocs.pm/elixir_scribe/api-reference.html) package can be installed
by adding `elixir_scribe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_scribe, "~> 0.1.0"}
  ]
end
```


## Documentation

The docs can be found at <https://hexdocs.pm/elixir_scribe>.

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc).


## Contributing

The Elixir Scribe tool is highly opinionated, therefore I ask you to first [open a discussion](https://github.com/Exadra37/elixir-scribe/discussions/new?category=ideas) to propose your idea to avoid working and then seeing the PR refused.

