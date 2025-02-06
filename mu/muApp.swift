//
//  muApp.swift
//  mu
//
//  Created by Bhargav Annem on 2/1/25.
//


import SwiftUI

@main
struct muApp: App {
    @StateObject private var workspaceState = WorkspaceState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workspaceState)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Open...") {
                    openItem()
                }
                .keyboardShortcut("O", modifiers: [.command])
            }
        }
    }
    
    func openItem() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["pdf"]
        
        if panel.runModal() == .OK, let url = panel.url {
            let isDirectory = (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
            
            if isDirectory {
                workspaceState.openWorkspace(url: url)
            } else {
                workspaceState.openIndividualPDF(url: url)
            }
        }
    }
}
