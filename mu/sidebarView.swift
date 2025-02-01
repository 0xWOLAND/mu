//
//  sidebarView.swift
//  mu
//
//  Created by Bhargav Annem on 2/1/25.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selectedPDF: URL?
    let root: FileNode

    var body: some View {
        List {
            OutlineGroup(root.children ?? [], children: \.children) { node in
                HStack {
                    Image(systemName: node.isFolder ? "folder" : "doc.pdf")
                    Text(node.url.lastPathComponent)
                }
                .onTapGesture {
                    if !node.isFolder {
                        selectedPDF = node.url
                    }
                }
            }
        }
        .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
    }
}

