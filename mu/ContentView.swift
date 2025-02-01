//
//  ContentView.swift
//  mu
//
//  Created by Bhargav Annem on 2/1/25.
//


import SwiftUI

struct ContentView: View {
    @State private var selectedPDF: URL? = nil
    let rootDirectory: FileNode

    var body: some View {
        NavigationView {
            SidebarView(selectedPDF: $selectedPDF, root: rootDirectory)
            if let pdf = selectedPDF {
                PDFViewer(url: pdf)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Select a PDF to view")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.gray)
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}
