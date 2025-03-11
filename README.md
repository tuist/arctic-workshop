# Tuist Workshop

In this workshop, we will explore [Tuist](https://tuist.dev) by creating a project and experimenting with various features.

The workshop is structured around a series of topics that are presented and should be followed sequentially. If, for any reason, you find yourself stuck in one of the topics, you will discover a commit SHA at the end of the topic that you can use to continue with the upcoming topics.

## Assert the successful completion of a topic

To assert the successful completion of a topic,
you can run the following command passing the topic number that you just completed

```bash
# Confirming the completion of step 1
bash <(curl -sSL https://raw.githubusercontent.com/tuist/arctic-workshop/main/assert.sh) 1
```

## Requirements

- Xcode 16
- [Tuist](https://docs.tuist.dev/en/guides/quick-start/install-tuist) 4.34.3

## Topics

1. [What is Tuist?](#1-what-is-tuist)
2. [Project creation](#2-project-creation)
3. [Project edition](#3-project-edition)
4. [Project generation](#4-project-generation)
5. [Multi-target project](#5-multi-target-project)
6. [Multi-project workspace](#6-multi-project-workspace)
7. [Sharing code across projects](#7-sharing-code-across-projects)
8. [XcodeProj-native integration of Packages](#8-xcodeproj-native-integration-of-packages)
9. [Focused projects](#9-focused-projects)
10. [Focused and binary-optimized projects](#9-focused-and-binary-optimized-projects)
11. [Selective tests](#11-selective-tests)
12. [Previews](#12-previews)

## 1. What is Tuist?

Tuist is a developer productivity platform to help teams overcome the challenges of scaling up development. Examples of challenges are:

- Git conflicts in Xcode projects.
- Inconsistencies across targets and projects.
- Unmaintainable target graph that creates strong dependencies with a platform team.
- Inefficient Xcode and clean builds.
- Suboptimal CI runs that lead to slow feedback loops.

Some of these are solved by the project generation, on which most of the workshop will be focused on.

### How do Tuist-generated projects work?

You describe your projects and workspaces in **Swift files (manifests)** using a Swift-based DSL.
We drew a lot of inspiration from the Swift Package Manager.
Unlike the Swift Package Manager, which is very focused on package management,
the APIs and models that you'll find in Tuist's DSL resemble Xcode projects and workspaces.

The following is an example of a typical Tuist project's structure:

```
Tuist.swift
Project.swift
```

### Install Tuist

Let's install Tuist first. While you can use Brew, we'll be using Mise for this workshop.

#### Installing Mise

Installing the [Mise CLI](https://mise.jdx.dev/getting-started.html#installing-mise-cli):
```sh
curl https://mise.run | sh
```

[Activating Mise](https://mise.jdx.dev/getting-started.html#activate-mise):
```sh
# bash
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
# zsh
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
# fish
echo '~/.local/bin/mise activate fish | source' >> ~/.config/fish/config.fish
```

#### Set up Tuist version with Mise

```bash
mise use tuist@latest
```

> [!IMPORTANT]
> Run the following to check if the step has been completed successfully:
> ```bash
> bash <(curl -sSL https://raw.githubusercontent.com/tuist/arctic-workshop/main/assert.sh) 1
> ```
> If you get stuck, you can continue from this point by running the following command:
> ```bash
> git checkout 1
> ```

## 2. Project creation

Tuist provides a command for creating projects,
`tuist init`,
but we are going to create the project manually to familiarize ourselves more deeply with the workflows and building blocks.

First of all, let's create a directory and call it `App`. Create it in this repository's directory:

```bash
mkdir -p App
cd App
```

Then we are going to create the following directories and files:

```bash
touch Project.swift
echo 'import ProjectDescription
let tuist = Tuist()' > Tuist.swift
```

> [!IMPORTANT]
> Run the following to check if the step has been completed successfully:
> ```bash
> bash <(curl -sSL https://raw.githubusercontent.com/tuist/arctic-workshop/main/assert.sh) 2
> ```
> If you get stuck, you can continue from this point by running the following command:
> ```bash
> git checkout 2
> ```


## 3. Project editing

Tuist provides a `tuist edit` command that generates an Xcode project on the fly to edit the manifests.
The lifecycle of the project is tied to the lifecycle of the `tuist edit` command.
In other words, when the edit command finishes, the project is deleted.

Let's edit the project:

```
tuist edit
```

Then add the following content to the `Project.swift`:

```swift
import ProjectDescription

let project = Project(name: "TuistApp", targets: [
    .target(name: "TuistApp", destinations: .iOS, product: .app, bundleId: "dev.tuist.TuistApp", sources: [
        "Sources/TuistApp/**/*.swift"
    ])
])
```

We are defining a project that contains an iOS app target that gets the sources from `Sources/TuistApp/**/*.swift`.
Then we need the app and the home view that the app will present when we launch it. For that, let's create the following files:

<details>
<summary>Sources/TuistApp/ContentView.swift</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}
```
</details>

<details>
<summary>Sources/TuistApp/TuistApp.swift</summary>

```swift
import SwiftUI

@main
struct TuistApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```
</details>

> [!IMPORTANT]
> Run the following to check if the step has been completed successfully:
> ```bash
> bash <(curl -sSL https://raw.githubusercontent.com/tuist/arctic-workshop/main/assert.sh) 3
> ```
> If you get stuck, you can continue from this point by running the following command:
> ```bash
> git checkout 3
> ```

## 4. Project generation

Once we have the project defined, we can generate it with `tuist generate`.
The command generates an Xcode project and workspace and opens it automatically.
If you don't want to open it by default, you can pass the `--no-open` flag:

```bash
tuist generate
```

Try to run the app in the generated project.

Note that Tuist generated also a `Derived/` directory containing additional files.
In some scenarios, for example, when you define the content of the `Info.plist` in code or use other features of Tuist,
it's necessary to create files that the generated Xcode projects and workspaces can reference.
Those are automatically generated under the `Derived/` directory relative to the directory containing the `Project.swift`:

The next thing that we are going to do is including the Xcode artifacts and the `Derived` directory in the `.gitignore`:

```
*.xcodeproj
*.xcworkspace
Derived/
.DS_Store
```

Thanks to the above change, the chances of Git conflicts are minimized considerably.

> [!IMPORTANT]
> Run the following to check if the step has been completed successfully:
> ```bash
> bash <(curl -sSL https://raw.githubusercontent.com/tuist/arctic-workshop/main/assert.sh) 4
> ```
> If you get stuck, you can continue from this point by running the following command:
> ```bash
> git checkout 4
> ```

## 5. Multi-target project

At some point in the lifetime of a project,
it becomes necessary to modularize a project into multiple targets.
For example to share source code across multiple targets.

Tuist supports that by abstracting away all the complexities that are associated with linking,
regardless of the complexity of your graph.

To see it in practice, we are going to create a new target called `TuistAppKit` that contains the logic for the app.
Then we are going to link the `TuistApp` target with the `TuistAppKit` target.

First, let's edit the `Project.swift` file:

```bash
tuist edit
```

And add the new target to the list:

```diff
import ProjectDescription

let project = Project(name: "TuistApp", targets: [
    .target(name: "TuistApp",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.TuistApp",
            sources: [
                "Sources/TuistApp/**/*.swift"
            ],
+            dependencies: [
+                .target(name: "TuistAppKit")
+            ]),
+    .target(
+        name: "TuistAppKit",
+        destinations: .iOS,
+        product: .framework,
+        bundleId: "dev.tuist.TuistAppKit",
+        sources: [
+            "Sources/TuistAppKit/**/*.swift"
+        ])
])
```

We can then create the following source file:

<details>
<summary>Sources/TuistAppKit/TuistAppKit.swift</summary>

```swift
import Foundation

public class TuistAppKit {
    public init() {}
    public func hallo() {}
}
```
</details>

And generate the project with `tuist generate`. Then import the framework from `TuistApp` and instantiate the above class to make sure the linking works successfully:

```diff
import SwiftUI
+import TuistAppKit

@main
struct TuistApp: App {
+    let kit = TuistAppKit()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

Run the app and confirm that everything works as expected.
Note how Tuist added a build phase to the `TuistApp` to embed the dynamic framework automatically. This is necessary for the dynamic linker to link the framework at launch time.

<!-- Notes
- Change the platform to macOS and show how it validates the graph.
- Change the type to static library and show how the embed build phase is gone.
 -->

> [!IMPORTANT]
> Run the following to check if the step has been completed successfully:
> ```bash
> bash <(curl -sSL https://raw.githubusercontent.com/tuist/arctic-workshop/main/assert.sh) 5
> ```
> If you get stuck, you can continue from this point by running the following command:
> ```bash
> git checkout 5
> ```

## 6. Multi-project workspace

Even though with Xcode projects and workspaces gitignored, there's less need for Xcode workspaces.
You might want to treat projects as an umbrella to group multiple targets that belong to the same domain and use workspaces to group all the projects.

Tuist supports that too.
To see it in practice, we are going to move the `Project.swift` under `Sources/TuistApp`:

```bash
mkdir Modules
mv Sources Modules

mkdir -p Modules/TuistApp/Sources
mv Modules/Sources/TuistApp/ContentView.swift Modules/TuistApp/Sources/ContentView.swift
mv Modules/Sources/TuistApp/TuistApp.swift Modules/TuistApp/Sources/TuistApp.swift

mkdir -p Modules/TuistAppKit/Sources
mv Modules/Sources/TuistAppKit/TuistAppKit.swift Modules/TuistAppKit/Sources/TuistAppKit.swift

touch Workspace.swift

cp Project.swift Modules/TuistApp/Project.swift
mv Project.swift Modules/TuistAppKit/Project.swift
```

We'll end up with the following directory structure:

```bash

├── Modules
│   ├── TuistApp
│   │   ├── Project.swift
│   │   └── Sources
│   │       ├── ContentView.swift
│   │       └── TuistApp.swift
│   └── TuistAppKit
│       ├── Project.swift
│       └── Sources
│           └── TuistAppKit.swift
├── Tuist
│   └── Config.swift
└── Workspace.swift
```

Note how we've organized the project in multiple modules, each of which has its own `Project.swift`. Now let's edit it with `tuist edit` and make sure we have the following content in the files:


<details>
<summary>Workspace.swift</summary>

```swift
import ProjectDescription

let workspace = Workspace(name: "TuistApp", projects: ["Modules/*"])
```
</details>

<details>
<summary>Modules/TuistApp/Project.swift</summary>

```swift
import ProjectDescription

let project = Project(
    name: "TuistApp",
    targets: [
        .target(
            name: "TuistApp",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.TuistApp",
            sources: [
                "Sources/**/*.swift"
            ],
            dependencies: [
                .project(target: "TuistAppKit", path: "../TuistAppKit")
            ])
    ])
```
</details>

<details>
<summary>Modules/TuistAppKit/Project.swift</summary>

```swift
import ProjectDescription

let project = Project(
    name: "TuistAppKit",
    targets: [
        .target(
            name: "TuistAppKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "dev.tuist.TuistAppKit",
            sources: [
                "Sources/**/*.swift"
            ]),
    ])
```
</details>

Generate the project and makes sure it compiles and runs successfully.

> [!IMPORTANT]
> Run the following to check if the step has been completed successfully:
> ```bash
> bash <(curl -sSL https://raw.githubusercontent.com/tuist/arctic-workshop/main/assert.sh) 6
> ```
> If you get stuck, you can continue from this point by running the following command:
> ```bash
> git checkout 6
> ```

## 7. Sharing code across projects

When you start splitting your project into multiple `Project.swift` a natural need for sharing code to ensure consistency arises.
Luckily, Tuist provides an answer for that, and it's called **Project Description Helpers**.
Let's create a folder `Tuist/ProjectDescriptionHelpers` and a file `Project+TuistApp.swift`:

```bash
mkdir -p Tuist/ProjectDescriptionHelpers
touch Tuist/ProjectDescriptionHelpers/Project+TuistApp.swift
```

Then let's edit the Tuist project with `tuist edit` and edit the following files:


<details>
<summary>Tuist/ProjectDescriptionHelpers/Project+TuistApp.swift</summary>

```swift
import ProjectDescription
import Foundation

public enum Module: String {
    case app
    case kit

    var product: Product {
        switch self {
        case .app:
            return .app
        case .kit:
            return .framework
        }
    }

    var name: String {
        switch self  {
        case .app: "TuistApp"
        default: "TuistApp\(rawValue.capitalized)"
        }
    }

    var dependencies: [Module] {
        switch self {
        case .app: [.kit]
        case .kit: []
        }
    }
}

public extension Project {
    static func tuist(module: Module) -> Project {
        let dependencies = module.dependencies.map({ TargetDependency.project(target: $0.name, path: "../\($0.name)") })
        return Project(name: module.name, targets: [
            .target(name: module.name,
                    destinations: .iOS,
                    product: module.product,
                    bundleId: "dev.tuist.\(module.name)",
                    sources: [
                        "./Sources/**/*.swift"
                    ],
                    dependencies: dependencies)
        ])
    }
}
```
</details>

<details>
<summary>Modules/TuistApp/Project.swift</summary>

```swift
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.tuist(module: .app)
```
</details>

<details>
<summary>Modules/TuistAppKit/Project.swift</summary>

```swift
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.tuist(module: .kit)
```
</details>

<!-- Notes
- Talk about how there's total flexibility about what can be added in the ProjectDescriptionsHelper module
- Mention that they can use their own abstractions to codify conventions.
-->

> [!IMPORTANT]
> Run the following to check if the step has been completed successfully:
> ```bash
> bash <(curl -sSL https://raw.githubusercontent.com/tuist/arctic-workshop/main/assert.sh) 7
> ```
> If you get stuck, you can continue from this point by running the following command:
> ```bash
> git checkout 7
> ```

## 8. XcodeProj-native integration of Packages

Tuist supports integrating Swift Packages into your projects using Xcode's standard integration.
However, that integration is not ideal at scale for a few reasons:

- Clean builds, which happen in CI environments and often locally when developers clean their environments to resolve cryptic Xcode errors, lead to the resolution and compilation of those packages, which slows the builds.
- There's little configurability of the integration, which creates a strong dependency on Apple to fix the issues that arise via their radar system.
- There's little room for optimization. For example to turn them into binaries and speed up clean builds.

Because of that, Tuist proposes a different integration method, which **takes the best of SPM and CocoaPods worlds.**
It uses SPM to resolve the packages, and CocoaPods' idea of integrating dependencies using XcodeProj primitives such as targets and build settings. Let's see how it works in action.

Create the following following file:

```bash
touch Tuist/Package.swift
```

With the following content:

<details>
<summary>Tuist/Package.swift</summary>

```swift
// swift-tools-version: 6.0
@preconcurrency import PackageDescription

let package = Package(name: "TuistApp", dependencies: [
    .package(url: "https://github.com/httpswift/swifter", .upToNextMajor(from: "1.5.0"))
])
```
</details>

Then run `tuist edit`, and include the dependency:

<details>
<summary>Tuist/ProjectDescriptionHelpers/Project+TuistApp.swift</summary>

```diff
import ProjectDescription

+public enum Dependency {
+    case module(Module)
+    case package(String)
+
+    var targetDependency: TargetDependency {
+        switch self {
+        case let .module(module): TargetDependency.project(target: module.name, path: "../\(module.name)")
+        case let .package(package): TargetDependency.external(name: package)
+        }
+    }
+}

public enum Module: String {
    case app
    case kit

    var product: Product {
        switch self {
        case .app:
            return .app
        case .kit:
            return .framework
        }
    }

    var name: String {
        switch self  {
        case .app: "TuistApp"
        default: "TuistApp\(rawValue.capitalized)"
        }
    }

+    var dependencies: [Dependency] {
+        switch self {
+        case .app: [.module(.kit)]
+        case .kit: [.package("Swifter")]
+        }
+    }
}

public extension Project {
    static func tuist(module: Module) -> Project {
+        let dependencies = module.dependencies.map(\.targetDependency)
        return Project(name: module.name, targets: [
            .target(name: module.name,
                    destinations: .iOS,
                    product: module.product,
                    bundleId: "dev.tuist.\(module.name)",
                    sources: [
                        "./Sources/**/*.swift"
                    ],
                    dependencies: dependencies)
        ])
    }
}
```
</details>

Note that we add a new `enum`, `Dependency` that we can use to model dependencies, which can now be of two types, `module` or `package`. The enum exposes a `targetDependency` property to return the value that targets need when defining their dependencies.

Now we need to run `tuist install`, which uses the Swift Package Manager to resolve the dependencies.
After they've been fetched, you can run `tuist generate` to generate the project and open it.

Then let's edit the `TuistApp.swift` to run the server when the view appears:

```diff
import SwiftUI
import TuistAppKit
+import Swifter

@main
struct TuistApp: App {
    let kit = TuistAppKit()

    var body: some Scene {
        WindowGroup {
            ContentView()
+                .onAppear(perform: {
+                    let server = HttpServer()
+                    server["/hello"] = { .ok(.htmlBody("You asked for \($0)"))  }
+                    try? server.start()
+                    print("Server running")
+                })
        }
    }
}
```

Before we wrap up this topic, add `Tuist/.build` to the `.gitignore`.

<!-- Notes
- Talk about how dependencies are integrated as Xcode projects
- Talk about how they can use the API in Dependencies.swift to override build settings and products.
-->

> [!IMPORTANT]
> Run the following to check if the step has been completed successfully:
> ```bash
> bash <(curl -sSL https://raw.githubusercontent.com/tuist/arctic-workshop/main/assert.sh) 8
> ```
> If you get stuck, you can continue from this point by running the following command:
> ```bash
> git checkout 8
> ```

## 9. Focused projects

When modular projects grow, it's common to face Xcode and compilation slowness.
It's normal, your project is large, and Xcode has a lot to index and process.
If you think about it, it doesn't make sense to load an entire graph of targets,
when you plan to only **focus** on a few of them.

Tuist provides an answer to that, and it's built into the command that you've been using since the beginning, `tuist generate`.

If you pass a list of targets that you plan to focus on, Tuist will generate projects with only the targets that you need to work on that one. For example, let's say we'd like to focus on `TuistAppKit`, for which we don't need `TuistApp`. We can then run:

```
tuist generate TuistAppKit
```

You'll notice that `TuistApp` will magically ✨ disappear from the generated project. If you want to include it too, you can pass it in the list of arguments:

```
tuist generate TuistApp TuistAppKit
```

Tuist gives developers an interface to **express their target of focus**.

## 10. Focused and binary-optimized projects

Tuist knows your project because you've described it to it, and this is very valuable information that can be used to perform powerful optimizations with little complexity for you.
One of them is what we call **binary caching**.

Tuist can turn targets of your graph, including packages, into binaries, and replace targets with their binaries at generation time.
Let's give it a shot:

```bash
tuist cache
tuist generate
```

By default, it tries to cache the dependencies. You can even cache your targets too. For example, if you want to focus on `TuistApp`, let's use a binary for everything else:

```bash
tuist generate TuistApp
```

> Note: You might need to delete the workspace to mitigate an Xcode issue parsing the workspace.

## 11. Selective tests

At a certain scale, running all tests can be time-consuming because you'll run tests that are not impacted by the changes you've made.
Tuist can selective runs them, and when combined with binary caching, you can speed up your CI workflows significantly–we've seen numbers around 80%.

Let's add some tests to `TuistAppKit` and run them selectively.

Create a file at `Modules/TuistAppKit/Tests/TuistAppKitTests.swift`:

<details>
<summary>Modules/TuistAppKit/Tests/TuistAppKitTests.swift</summary>

```swift
import Testing

@Test func example() {
    #expect(true == true)
}
```

</details>

Then update `Tuist/ProjectDescriptionHelpers/Project+TuistApp.swift` to include the tests:

<details>
<summary>Tuist/ProjectDescriptionHelpers/Project+TuistApp.swift</summary>

```swift
import ProjectDescription

public enum Dependency {
    case module(Module)
    case package(String)

    var targetDependency: TargetDependency {
        switch self {
        case let .module(module): TargetDependency.project(target: module.name, path: "../\(module.name)")
        case let .package(package): TargetDependency.external(name: package)
        }
    }
}

public enum Module: String {
    case app
    case kit

    var product: Product {
        switch self {
        case .app:
            return .app
        case .kit:
            return .framework
        }
    }

    var name: String {
        switch self  {
        case .app: "TuistApp"
        default: "TuistApp\(rawValue.capitalized)"
        }
    }

    var dependencies: [Dependency] {
        switch self {
        case .app: [.module(.kit)]
        case .kit: [.package("Swifter")]
        }
    }

+    var hasTests: Bool {
+        switch self {
+        case .app: return false
+        case .kit: return true
+        }
+    }
}

public extension Project {
    static func tuist(module: Module) -> Project {
        let dependencies = module.dependencies.map(\.targetDependency)
+        var targets: [Target] = [
+            .target(name: module.name,
+                    destinations: .iOS,
+                    product: module.product,
+                    bundleId: "dev.tuist.\(module.name)",
+                    sources: [
+                        "./Sources/**/*.swift"
+                    ],
+                    dependencies: dependencies)
+        ]
+        if module.hasTests {
+            targets.append( .target(name: "\(module.name)Tests",
+                                    destinations: .iOS,
+                                    product: .unitTests,
+                                    bundleId: "dev.tuist.\(module.name)Tests",
+                                    sources: [
+                                        "./Tests/**/*.swift"
+                                    ],
+                                    dependencies: [.target(name: module.name)]))
+        }
+        return Project(name: module.name, targets: targets)
    }
}
```
</details>

> [!IMPORTANT]
> Run the following to check if the step has been completed successfully:
> ```bash
> bash <(curl -sSL https://raw.githubusercontent.com/tuist/arctic-workshop/main/assert.sh) 11
> ```
> If you get stuck, you can continue from this point by running the following command:
> ```bash
> git checkout 11
> ```

**Challenge:** Add an example module in the `tuist` `module` factory, similar to unit tests.

## 12. Remote binary cache and selective tests

So far, we've been able to cache binaries and selective test results in our local environment. However, wouldn't it be great if we could share those across the team?

For that, we'll need a Tuist account:

```bash
tuist auth login
```

And a Tuist project on the Tuist server:

```bash
tuist project create marekfort/workshop
```

> [!NOTE]
> `marekfort` is your account handle. You can check out in the URL when visiting the dashboard at [https://tuist.dev](https://tuist.dev)

Then, let's update the `Tuist.swift` file to include the project handle:

```swift
import ProjectDescription

let tuist = Tuist(fullHandle: "marekfort/workshop")
```

Now, we can clean our results locally:
```bash
tuist clean selectiveTests binaries
```

We'll re-run the commands again to cache the results remotely and then clean again:

```bash
tuist cache
tuist test
tuist clean selectiveTests binaries
```

Now, when running `tuist generate App`, `tuist` will automatically pull the binaries! And the same goes for selective test results.

> [!TIP]
> You can use `tuist cache --print-hashes` to see the hashes of the targets that will be cached. These hashes are also available in the Tuist dashboard.


## 13. Previews

Previewing changes fast can foster collaboration and speed up development.
Tuist solves that with previews.

To share the app with the team, run:

```
tuist share TuistApp
```

Then you can click on the link to run the app through the macOS app, which you can install [using this link](https://tuist.dev/download).

> [!NOTE]
> Previews can be accessed by anyone who's member to an organization's account. Teams can post previews on PRs that can be easily opened by anyone reviewing the PR by just clicking on the link.

### 14. Dynamic configuration

Let's visualize our project using the `tuist graph` command to see the current structure of our graph.

By default, `tuist graph` generates an image. However, you can also generate a JSON file by passing the `--format json` flag. The output of this command is using the [XcodeGraph](https://github.com/tuist/xcodegraph) library.

What we want to be able to run is `TUIST_DEFAULT_PRODUCT="static_framework" tuist generate` to change our default product type to a static framework.

We can achieve that by using the environment variable in the `Tuist/ProjectDescriptionHelpers/Project+TuistApp.swift`:

<details>
<summary>Tuist/ProjectDescriptionHelpers/Project+TuistApp.swift</summary>

```swift
import ProjectDescription
import Foundation

public enum Dependency {
    case module(Module)
    case package(String)

    var targetDependency: TargetDependency {
        switch self {
        case let .module(module): TargetDependency.project(target: module.name, path: "../\(module.name)")
        case let .package(package): TargetDependency.external(name: package)
        }
    }
}

public enum Module: String {
    case app
    case kit

    var product: Product {
        switch self {
        case .app:
            return .app
        case .kit:
+           switch Environment.defaultProduct {
+           case .string("static_framework"):
+               return .staticFramework
+           default:
+               return .framework
+           }
+       }
    }

    var name: String {
        switch self  {
        case .app: "TuistApp"
        default: "TuistApp\(rawValue.capitalized)"
        }
    }

    var dependencies: [Dependency] {
        switch self {
        case .app: [.module(.kit)]
        case .kit: [.package("Swifter")]
        }
    }

    var hasTests: Bool {
        switch self {
        case .app: return false
        case .kit: return true
        }
    }
}

public extension Project {
    static func tuist(module: Module) -> Project {
        let dependencies = module.dependencies.map(\.targetDependency)
        var targets: [Target] = [
            .target(name: module.name,
                    destinations: .iOS,
                    product: module.product,
                    bundleId: "dev.tuist.\(module.name)",
                    sources: [
                        "./Sources/**/*.swift"
                    ],
                    dependencies: dependencies)
        ]
        if module.hasTests {
            targets.append( .target(name: "\(module.name)Tests",
                                    destinations: .iOS,
                                    product: .unitTests,
                                    bundleId: "dev.tuist.\(module.name)Tests",
                                    sources: [
                                        "./Tests/**/*.swift"
                                    ],
                                    dependencies: [.target(name: module.name)]))
        }
        return Project(name: module.name, targets: targets)
    }
}
```

</details>

Let's now run the `generate` command and inspect the generated project:
```sh
TUIST_DEFAULT_PRODUCT="static_framework" tuist generate
# We can visualize the graph by running:
TUIST_DEFAULT_PRODUCT="static_framework" tuist graph
```

### 15. Implicit dependencies

One of the common issues that makes builds less deterministic and can make `tuist cache` less reliabl are implicit dependencies.

Let's create such an example by moving the `.package("Swifter")` dependency from `TuistAppKit` to `TuistApp` in the `Tuist/ProjectDescriptionHelpers/Project+TuistApp.swift` file:
```swift
var dependencies: [Dependency] {
    switch self {
    case .app: [.module(.kit), .package("Swifter")]
    case .kit: []
    }
}
```

Let's also add `import Swifter` to `Modules/TuistAppKit/Sources/TuistAppKit.swift`:
```swift
import Foundation
import Swifter

public class TuistAppKit {
    public init() {}
    public func hallo() {}
}
```

Let's generate our project and try the following:
- Build the `TuistApp` scheme – why does it build when `Swifter` should not be available?
- Build the `TuistAppKit` scheme – the project is still buildable, why?
- Let's clean the derived data and try to build the `TuistAppKit` scheme. The project now doesn't compile.

We can use again the `tuist graph` to visualize the project to better understand why.

What can we do against this?

Tuist has a command just for this:
```swift
tuist inspect implicit-imports
```

We can now remove the extra import in `Modules/TuistAppKit/Sources/TuistAppKit.swift`. The `tuist inspect implicit-imports` command should now succeed.

### 16. Custom XcodeGraph automations

Wouldn't it be great if we could write our own automations that can be run on the XcodeGraph output?

Thanks to [XcodeGraph](https://github.com/tuist/xcodegraph), we can do exactly that.

Let's write a simple automation that will check all targets start with a capital letter. We'll start by going to a new directory where we'll work on the package:
```
cd ../App
mkdir my-linter
swift package init --name my-linter --type executable
mkdir Sources/my-linter
mv Sources/main.swift Sources/my-linter/main.swift
```

Let's now edit the `Package.swift` file to include dependencies we'll need:

<details>
<summary>Package.swift</summary>

```swift
// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "my-linter",
    platforms: [.macOS("13.0")],
    products: [
        .executable(name: "my-linter", targets: ["my-linter"])
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/XcodeGraph", from: "1.8.9"),
        .package(url: "https://github.com/tuist/Command", from: "0.13.0"),
        .package(url: "https://github.com/tuist/FileSystem", from: "0.7.7"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "my-linter",
            dependencies: [
                .product(name: "XcodeGraph", package: "XcodeGraph"),
                .product(name: "Command", package: "Command"),
                .product(name: "FileSystem", package: "FileSystem"),
            ]
        )
    ]
)
```

</details>

And now we can write our linter in the `main.swift` file:

<details>
<summary>Sources/my-linter/main.swift</summary>

```swift
@preconcurrency import XcodeGraph
import FileSystem
import Command
import Foundation

let commandRunner = CommandRunner()
try await commandRunner
    // When running this command in Xcode, supply the full path to tuist. Get it by running `which tuist`
    .run(arguments: ["tuist", "graph", "--format", "json"], environment: ProcessInfo.processInfo.environment)
    .awaitCompletion()
let fileSystem = FileSystem()
let graph: Graph = try await fileSystem.readJSONFile(
    at: try await fileSystem.currentWorkingDirectory().appending(component: "graph.json")
)

let targets = graph.projects.values.flatMap(\.targets).map(\.value)
    .filter {
        return $0.name.first?.isUppercase == false
    }

if targets.isEmpty {
    print("All targets start with a capital letter")
    exit(0)
} else {
    print("The following targets don't start with a capital letter: \(targets.map(\.name).joined(separator: ", "))")
    exit(1)
}
```

</details>

Let's check the linter works by running it from the `App` directory:
```sh
swift run --package-path ../my-linter my-linter
```

When we update one of our target names not to start with a capital letter in the `Tuist/ProjectDescriptionHelpers/Project+TuistApp.swift` file, running the command should now fail.

**Challenge**: Think of a rule that you'd like to enforce in your projects and write a linter for it. Create this in a separate repository and share it with others.
_Bonus_: We can use [Noora](https://github.com/tuist/Noora/) to make the output more appealing and the [ArgumentParser](https://github.com/apple/swift-argument-parser) to pass and parse arguments.

> [!TIP]
> You can run arbitrary Swift CLIs with just a URL by running leveraging the Mise SwiftPM backend, such as: `mise x spm:https://github.com/nicklockwood/SwiftFormat.git@main -- swiftformat --version`

### 17. Registry

[Swift Package Registry](https://github.com/swiftlang/swift-package-manager/blob/main/Documentation/PackageRegistry/PackageRegistryUsage.md) is a Swift standard for making Swift package resolutions more deterministic, space-efficient, and faster.

Tuist has implemented this standard and includes all packages that you can find in the [Swift Package Index](https://swiftpackageindex.com/).

Let's resolve our App packages using the Tuist Registry instead of source control.

We'll update the `Tuist/Package.swift` to reference the `Swifter` package with a registry identifier instead of a URL:
```swift
// swift-tools-version: 6.0
@preconcurrency import PackageDescription

let package = Package(
    name: "TuistApp",
    dependencies: [
+       .package(id: "httpswift.swifter", .upToNextMajor(from: "1.5.0"))
    ])
```

We will also need to set up the registry:
```sh
tuist registry setup
tuist registry login
```

Let's now inspect how big our `Tuist/.build` directory is before resolving packages with the registry:
```sh
du -sh Tuist/.build
```

And now we can resolve the packages with the registry and compare the size:
```sh
tuist install
du -sh Tuist/.build
```

The checked out directories are usually by 80 % larger when using the registry. Not only we can save space, but we can also speed up the incremental resolution process on [the CI dramatically](https://docs.tuist.dev/en/guides/develop/registry/continuous-integration#incremental-resolution-across-environments).


### 18. Non-generated projects

Wouldn't it be great if you could get most of the above benefits without having to migrate your project to be generated with Tuist? Well, you can!

Let's create a completely new Xcode project and explore commands compatible with non-generated projects, such as:
- Selective testing
  - Run `tuist xcodebuild test --project App.xcodeproj --scheme App`
- `tuist graph`
- Registry
  - Set up a Tuist project and create an accompanying `Tuist.swift` file
  - `tuist registry setup`
  - `tuist registry login`
  - Add a package from registry using Xcode's UI
- Previews
  - Build the app in Xcode
  - Run `tuist share App --platforms iOS`
- ...and soon more!

<!--
- Possible workshop extensions:
- tuist inspect build
- New tuist init experience
- Show dashboard of the runs
- Tuist reports
- Add feature modules as another layer
- How to contribute to Tuist
-->
