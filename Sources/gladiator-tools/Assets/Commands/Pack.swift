//
//  Pack.swift
//  
//
//  Created by Pavel Kasila on 11/24/20.
//

import Foundation
import AssetManager
import ArgumentParser

extension AssetBuilder {
    struct Pack: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Work with pack",
            subcommands: [Build.self, Index.self, ExtractTexture.self]
        )
    }
}

extension AssetBuilder.Pack {
    struct Build: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Builds pack of assets for the engine")

        @Argument(help: "Files to work on")
        var files: [String] = []
        
        @OptionGroup
        var options: OutputOptions

        mutating func run() throws {
            let assets = try files.map { file -> RawAsset in
                let d = try Data(contentsOf: URL(fileURLWithPath: file))
                return RawAsset(rawData: d.subdata(in: 0..<d.endIndex-64))
            }
            
            AssetManager.saveAssetPack(assets: assets, path: options.outputPath)
        }
    }
    
    struct PackOptions: ParsableArguments {
        @Argument(help: "Pack path")
        var pack: String
    }
    
    struct Index: ParsableCommand {
        @OptionGroup
        var options: PackOptions

        mutating func run() throws {
            let manager = AssetManager()
            try manager.loadAssetPack(path: options.pack)
            
            print("Textures: ")
            for (i, texture) in manager.textures.enumerated() {
                print("Texture #\(i) - \(texture.assetData().count) bytes")
            }
        }
    }
    
    struct ExtractTexture: ParsableCommand {
        @OptionGroup
        var outputOptions: OutputOptions
        
        @OptionGroup
        var options: PackOptions
        
        @Argument(help: "Texture ID")
        var textureID: Int

        mutating func run() throws {
            let manager = AssetManager()
            try manager.loadAssetPack(path: options.pack)
            
            if let texture = manager.textures[safe: textureID] {
                AssetManager.saveAsset(path: outputOptions.outputPath, asset: texture)
            } else {
                throw AssetBuilderError.assetNotFound(type: .texture, id: textureID)
            }
        }
    }
}
