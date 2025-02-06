//
//  sidebarView.swift
//  mu
//
//  Created by Bhargav Annem on 2/1/25.
//

import SwiftUI

import UniformTypeIdentifiers
struct SidebarView: View {
    @EnvironmentObject var workspaceState: WorkspaceState
    
    var body: some View {
        List {
            // Open PDFs Section
            if !workspaceState.openPDFs.isEmpty {
                Section("Open PDFs") {
                    ForEach(workspaceState.openPDFs) { node in
                        HStack {
                            Image(systemName: "doc.pdf")
                            Text(node.url.lastPathComponent)
                            Spacer()
                            Button(action: {
                                workspaceState.closePDF(url: node.url)
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onTapGesture {
                            workspaceState.selectedPDF = node.url
                        }
                        .background(workspaceState.selectedPDF == node.url ? Color.accentColor.opacity(0.1) : Color.clear)
                    }
                }
            }
            
            // Workspace Section
            if let root = workspaceState.workspaceRoot {
                Section("Workspace") {
                    OutlineGroup(root.children ?? [], children: \.children) { node in
                        HStack {
                            Image(systemName: node.isFolder ? "folder" : "doc.pdf")
                            Text(node.url.lastPathComponent)
                        }
                        .onTapGesture {
                            if !node.isFolder {
                                workspaceState.selectedPDF = node.url
                            }
                        }
                        .background(workspaceState.selectedPDF == node.url ? Color.accentColor.opacity(0.1) : Color.clear)
                    }
                }
            }
        }
        .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
    }
}
