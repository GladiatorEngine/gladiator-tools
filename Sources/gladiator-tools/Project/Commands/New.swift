//
//  New.swift
//  gladiator-tools
//
//  Created by Pavel Kasila on 11/25/20.
//

import Foundation
import ArgumentParser

extension Project {
    struct New: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Create new project from template")
        
        @Argument(help: "Path where your new project will be created")
        var projectPath: String

        mutating func run() throws {
            let projectURL = URL(fileURLWithPath: projectPath)
            let projectName = projectURL.absoluteURL.lastPathComponent
            
            print("Creating new project \"\(projectName)\"")
            
            func runShell(script: String) {
                let process = Process()
                process.executableURL = URL(fileURLWithPath:"/bin/bash")
                process.arguments = ["-c", script]
                do {
                    try process.run()
                    process.waitUntilExit()
                } catch {}
            }
            
            // Download file with git
            
            if !FileManager.default.fileExists(atPath: projectURL.path) {
                runShell(script: "git clone https://github.com/GladiatorEngine/TechnologyDemo.git \(projectURL.path)")
                
                runShell(script: "open \(projectURL.path)")
            } else {
                print("There is something stored in path \(projectURL.path)")
            }
        }
    }
}

// MARK: - Errors

enum NewProjectCreationError: Error {
    case cannotCreateTempDirectory
}
