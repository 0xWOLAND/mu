//
//  muApp.swift
//  mu
//
//  Created by Bhargav Annem on 2/1/25.
//


import SwiftUI


@main
struct muApp: App {
    @State private var rootDirectory: FileNode? = nil

    var body: some Scene {
        WindowGroup {
            if let directory = rootDirectory {
                ContentView(rootDirectory: directory)
            } else {
                ContentView(rootDirectory: FileNode(url: URL(fileURLWithPath: "/"))) // Provide a default
            }
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Open Folder…") {
                    openFolder()
                }
                .keyboardShortcut("O", modifiers: [.command])
            }
        }
    }

    func openFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            rootDirectory = FileNode.loadPDFs(from: url)
        }
    }
}
