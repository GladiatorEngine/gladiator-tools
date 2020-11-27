//
//  Model.swift
//  
//
//  Created by Pavel Kasila on 11/24/20.
//

import Foundation
import ArgumentParser
import AssetManager

extension AssetBuilder {
    struct Model: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Work with models",
            subcommands: [Build.self, ToVerticesJSON.self]
        )
    }
}

extension AssetBuilder.Model {
    struct Build: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Builds GEA-model for the engine")

        @Option(name: .shortAndLong, help: "Vertices JSON path")
        var vertices: String
        
        @OptionGroup
        var options: OutputOptions

        mutating func run() throws {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: vertices))
            
            let vertices = try JSONDecoder().decode([[Float]].self, from: jsonData)
            
            let model = Model(vertices: vertices.map { v in
                Vertex(coordinate: .init(x: v[0], y: v[1], z: v[2]))
            })
            AssetManager.saveAsset(path: options.outputPath, asset: model)
        }
    }
    
    struct ModelOptions: ParsableArguments {
        @Argument(help: "Model path")
        var model: String
    }
    
    struct ToVerticesJSON: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Converts GEA-model to vertices JSON file")

        @OptionGroup
        var options: ModelOptions
        
        @OptionGroup
        var outputOptions: OutputOptions

        mutating func run() throws {
            let manager = AssetManager()
            try manager.loadModelAsset(path: options.model)
            
            let data = try JSONEncoder().encode(manager.models[0].vertices.map { v in
                return [v.coordinate.x, v.coordinate.y, v.coordinate.z, 1]
            })
            
            try data.write(to: URL(fileURLWithPath: outputOptions.outputPath))
        }
    }
}
