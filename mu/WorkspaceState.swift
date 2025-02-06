//
//  WorkspaceState.swift
//  mu
//
//  Created by Bhargav Annem on 2/6/25.
//

import SwiftUI

class WorkspaceState: ObservableObject {
    @Published var workspaceRoot: FileNode?
    @Published var openPDFs: [FileNode] = []
    @Published var selectedPDF: URL?
    
    func openWorkspace(url: URL) {
        workspaceRoot = FileNode.loadPDFs(from: url)
    }
    
    func openIndividualPDF(url: URL) {
        // Check if PDF is already open
        if !openPDFs.contains(where: { $0.url == url }) {
            let pdfNode = FileNode(url: url)
            openPDFs.append(pdfNode)
        }
        selectedPDF = url
    }
    
    func closePDF(url: URL) {
        openPDFs.removeAll { $0.url == url }
        if selectedPDF == url {
            selectedPDF = openPDFs.last?.url ?? workspaceRoot?.children?.first?.url
        }
    }
}
