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
