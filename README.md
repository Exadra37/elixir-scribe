# 🪶 Elixir Scribe 📜

Scribes were an elite in ancient societies, highly regarded and holding special social status. They were disciplined and known for their excellent craftsmanship in writing laws, copying documents, and other related tasks.

The motivation to create the Elixir Scribe tool was to encourage developers to write **Clean Code** in a **Clean Software Architecture**, to enable them to know in seconds all domains, resources, and actions used in a project, while reducing complexity and contributing for less technical debt.

The Elixir Scribe tool enables developers craftsmanship and professionalism to reach new levels never imagined before or thought to not be easy to achieve.

Don't just be a Developer or Engineer, become a Scribe Developer and Engineer 🚀

> **IMPORTANT**: The Elixir Scribe tool is not about implementing Domain Driven Design (DDD), but may share some similarities.


### TOC

* [Reduced Complexity Equals to Less Technical Debt](#reduced-complexity-equals-to-less-technical-debt)
* [Clean Software Architecture](#clean-software-architecture)
* [Clean Code](#clean-code)
* [Benefits](#benefits)
* [Installation](#installation)
* [Quickstart](#quickstart)
* [Documentation](#documentation)
* [Contributing](#contributing)
* [Roadmap](#roadmap)


## Reduced Complexity Equals to Less Technical Debt

The Elixir Scribe generators will help developers to effortless organize their code by Domain, Resource and all possible actions on the Resource to reduce complexity and technical debt.

This reduction in complexity translates into fewer bugs and makes it easier to add new features and implement bug fixes when they arise. Consequently, this results in less maintenance and technical debt across the lifetime of a project, leading to a more robust and easier-to-work-with code-base.

Ultimately, this enhances developer experience, velocity and productivity. This is a win win for both the business and developers.

[TOC](#toc)


## Clean Software Architecture

A Clean Software Architecture **MUST** allow developers to understand in seconds, or in a couple of minutes, all Domains, Resources and actions of the project they are working on.

Can you grasp, in seconds, all domains, resources, and actions in your current large professional or side projects? With the Elixir Scribe folder structure you will always reply **YES** to the this question.

Let's do an exercise. How much time do you need to know all domains, resources and actions from the below fictitious `acme` app?

The below folder structure reflects the Elixir Scribe generator used in the [Quickstart](#quickstart):

```text
$ tree -d -L 5 lib

lib
├── my_app
│   └── domains
│       ├── catalog
│       │   ├── category
│       │   │   ├── create
│       │   │   ├── delete
│       │   │   ├── edit
│       │   │   ├── export
│       │   │   ├── import
│       │   │   ├── list
│       │   │   ├── new
│       │   │   ├── read
│       │   │   └── update
│       │   └── product
│       │       ├── create
│       │       ├── delete
│       │       ├── edit
│       │       ├── export
│       │       ├── import
│       │       ├── list
│       │       ├── new
│       │       ├── read
│       │       └── update
│       └── warehouse
│           └── stock
│               ├── export
│               └── import
└── my_app_web
    ├── components
    │   └── layouts
    └── domains
        ├── catalog
        │   ├── category
        │   │   ├── create
        │   │   ├── delete
        │   │   ├── edit
        │   │   ├── export
        │   │   ├── import
        │   │   ├── list
        │   │   ├── new
        │   │   ├── read
        │   │   └── update
        │   └── product
        │       ├── create
        │       ├── delete
        │       ├── edit
        │       ├── export
        │       ├── import
        │       ├── list
        │       ├── new
        │       ├── read
        │       └── update
        └── warehouse
            └── stock
                ├── export
                └── import

```

> **Domains:** catalog, warehouse  
> **Resources:** category, product, stock  
> **Actions:** create, delete, edit, export, import, list, new, read, update  

So, how many seconds did it took you to have an overview of the project and understand all it's Domains, Resources and Actions? How much time do you think you would spend looking through the code-base to find where to fix a bug to `export` a Product or to add a new feature to the Category resource?

This is a very simplistic view of a project. Now, imagine reaping the benefits of this folder structure implemented on your huge code-base, which may now contain dozens, hundreds, or even thousands of resources *(yes, I worked in such a project)*, each with potentially more actions than the ones exemplified here.

Take a moment to compare this folder structure with the traditional ones used in any project you worked so far, be it an Elixir / Phoenix project or not, which often condenses several resources and all their actions into a single module / class, without even care about Domain boundaries. 

[TOC](#toc)


## Clean Code

Writing Clean Code relies on several aspects, and one of them is to follow the Single Responsibility Principle, which is encouraged by the Elixir Scribe tool, when it forces the developer to split all possible actions on a Resource into a single module by action on a Resource.

The Developer can still manage to mix responsibilities in the action module for the Resource. For example, any access to a third party service should be delegated to another module. The action module should do only one thing, to handle the data as per the businesses rules.

The Elixir Scribe tool doesn't enforce an architecture inside the action folder, leaving the Developer free to apply the best one for it's use case. For example, the module generated by the Elixir Scribe tool inside the action folder may be used as an entry-point to orchestrate all required steps to perform the action on the Resource, which will be done in other modules to follow the Single Responsibility Principle, reduce complexity per module, resulting in a Clean Code that it's easier to understand and maintain.

Can you now understand why Elixir Scribe encourages developers to write **Clean Code** in a **Clean Software Architecture**?

[TOC](#toc)


## Benefits

The main benefits of using the Elixir Scribe Tool to create and maintain Elixir and Phoenix projects:

* Know in seconds all domains, resources, and actions used in your project by just looking at the folder structure. This is priceless for anyone working on the project.
* Newcomers to the project or anyone returning after a while can easily understand what the project is all about and quickly start working on new features or bugs (folder structure for the win).
* The single responsibility principle is encouraged by the design of the folder structure, where a clear separation of domains, resources, and actions occurs, encouraging one resource action per module.
* Helps to reduce tech debt due to the separation of concerns encouraged by the folder structure, which naturally guides developers to not mix new features into an existing module, whether it's a new domain, resource, or just an action on a resource.
* It's much easier to find where to add a new feature without mixing it with existing code. For example: If it's a new action on a resource, just add one more action folder and the respective module(s) inside it.
* Quickly find and start debugging a bug because actions aren't entangled in a huge module with several resources for a domain (context). For example, if the bug is about creating a resource on a given domain, it's straightforward to know where to start due to the folder structure.
* Each resource on a domain has a public API to avoid direct access to the underlying implementation of each resource. This removes cross-domain boundary calls into the internals of each resource implementation, preventing the coupling of domains, which is a significant source of technical debt and complexity in a codebase. The Resource public API MUST be used not only from other domains but also from within the domain itself. This will allow the internals of a resource in a domain to change as needed, provided that we do not affect the public API for it.
* The folder structure is documentation that never lies about what domains (contexts), resources, and actions are available in your project, whether huge or small.

[TOC](#toc)


## Installation

The [Elixir Scribe](https://hexdocs.pm/elixir_scribe/api-reference.html) package can be installed
by adding `elixir_scribe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_scribe, ">= 0.1.0", only: :dev}
  ]
end
```

[TOC](#toc)


## Quickstart

Let's create a fictitious Online Shop to exemplify how to use the Elixir Scribe tool:

```
mix phx.new my_app --database sqlite3
```

Now let's use the Elixir Scribe generators to create the domain `Catalog` and add to it the resource `Category` with the default actions:

```
mix scribe.gen.html Catalog Category categories name:string desc:string --web Catalog
```

> Elixir Scribe default actions: create, delete, edit, list, new, read, update


Let's add to the domain `Catalog` the resource `Product` with custom actions on top of the default actions:

```
mix scribe.gen.html Catalog Product products name:string desc:string --web Catalog --actions batch_create,batch_update
```

Let's add the domain `Warehouse` with the resource `Iventory` without default actions. We will need to provide custom actions:

```
mix scribe.gen.html Warehouse Inventory inventories name:string desc:string --web Warehouse --actions batch_create,batch_update --no-default-actions
```

[TOC](#toc)


## Documentation

The docs can be found at <https://hexdocs.pm/elixir_scribe>.

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc).

[TOC](#toc)


## Contributing

The Elixir Scribe tool is highly opinionated, therefore I ask you to first [open a discussion](https://github.com/Exadra37/elixir-scribe/discussions/new?category=ideas) to propose your idea to avoid working and then seeing the PR refused.

[TOC](#toc)


## Roadmap

### Elixir Scribe Generators

- [ ] Mix task: `scribe.gen.domain`
- [ ] Mix task: `scribe.gen.html`
- [ ] Mix task: `scribe.gen.live`
- [ ] Mix task: `scribe.gen.home`
  * Removes current default Home page.
  * Adds new Home page with links to each Domain and Resource.
- [ ] Mix task: `scribe.gen.ci` 
  * Generates a CI file for Github or Gitlab with at least the following:
    + `mix format --dry-run --check-formatted`
    + `mix deps.unlock --check-unused`
    + `mix deps.audit`
    + `mix hex.audit`
    + `mix sobelow`
    + `mix credo`
    + `mix doctor`
    + `mix test --cover`
- [ ] Mix task: `scribe.gen.project` -> Generates all Domains, Resources and Actions from an Elixir Scribe spec module `%ElixirScribe.ProjectSpecs{}`. 
- [ ] Mix task: `scribe.gen.api`
- [ ] Mix task: `scribe.gen.native`
  * Enables the project to be built for Desktop, Android and Apple.
  * Elixir libraries to build for native targets:
    + [LiveView Native](https://github.com/liveview-native)
    + [Elixir Desktop](https://github.com/elixir-desktop/desktop)
    + [ExTauri](https://github.com/Exadra37/ex_tauri)
- [ ] Mix task: `scribe.gen.admin`

### Improvements

- [ ] Optimize default HTMl layout and components for a more clean and usable UI.
  - [ ] Table headers in Bold
  - [ ] Highlight links in blue, not in bold (black).
- [ ] Add Authentication by default to all pages, except Home page.
- [ ] Add dynamic API key (only valid for one request)
- [ ] Add Remote Configuration for mobile apps
