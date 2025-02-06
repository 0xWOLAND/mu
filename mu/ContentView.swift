//
//  ContentView.swift
//  mu
//
//  Created by Bhargav Annem on 2/1/25.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var workspaceState: WorkspaceState
    
    var body: some View {
        NavigationView {
            SidebarView()
            if let selectedPDF = workspaceState.selectedPDF {
                PDFViewer(url: selectedPDF)
            } else {
                Text("No PDF Selected")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .environmentObject(workspaceState)
    }
}
