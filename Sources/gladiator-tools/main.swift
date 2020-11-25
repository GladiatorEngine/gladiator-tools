import Foundation
import ArgumentParser

struct GladiatorTools: ParsableCommand {
    static var configuration = CommandConfiguration(
        // Optional abstracts and discussions are used for help output.
        abstract: "GladiatorEngine toolset which helps developer to work with projects based on GE",

        // Commands can define a version for automatic '--version' support.
        version: "1.0.0",
        
        subcommands: [AssetBuilder.self, Project.self])
}

struct OutputOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Output path")
    var outputPath: String = "output.gea"
}

GladiatorTools.main()
