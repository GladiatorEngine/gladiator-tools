import Foundation
import ArgumentParser
import AssetManager

struct AssetBuilder: ParsableCommand {
    static var configuration = CommandConfiguration(
        // Optional abstracts and discussions are used for help output.
        abstract: "Allows to create Gladiator Engine Asset Packs and more",
        
        subcommands: [Texture.self, Pack.self, Model.self])
}
