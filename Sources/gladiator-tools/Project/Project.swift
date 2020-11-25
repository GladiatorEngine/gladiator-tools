//
//  Project.swift
//  gladiator-tools
//
//  Created by Pavel Kasila on 11/25/20.
//

import Foundation
import ArgumentParser

struct Project: ParsableCommand {
    static var configuration = CommandConfiguration(
        // Optional abstracts and discussions are used for help output.
        abstract: "Allows to manage project and create new one from TechnologyDemo template",
        
        subcommands: [New.self])
}
