//
//  pdfViewer.swift
//  mu
//
//  Created by Bhargav Annem on 2/1/25.
//

import SwiftUI
import PDFKit
import AppKit

struct PDFViewer: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true

        if let document = PDFDocument(url: url) {
            pdfView.document = document
            restoreLastPage(pdfView, for: url)
        }

        return pdfView
    }

    func updateNSView(_ nsView: PDFView, context: Context) {
        if let previousURL = context.coordinator.lastOpenedURL {
            saveCurrentPage(nsView, for: previousURL)
        }

        if let document = PDFDocument(url: url) {
            nsView.document = document
            restoreLastPage(nsView, for: url)
        }

        context.coordinator.lastOpenedURL = url
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    private func saveCurrentPage(_ pdfView: PDFView, for documentURL: URL) {
        guard let document = pdfView.document,
              let currentPage = pdfView.currentPage else { return }

        let pageNumber = document.index(for: currentPage)  // Always an Int

        UserDefaults.standard.set(pageNumber, forKey: documentURL.path)
        UserDefaults.standard.synchronize()
        print("Saved page: \(pageNumber + 1) for \(documentURL.lastPathComponent)")
    }

    private func restoreLastPage(_ pdfView: PDFView, for documentURL: URL) {
        guard let document = pdfView.document else { return }

        if let lastPageIndex = UserDefaults.standard.value(forKey: documentURL.path) as? Int,
           let page = document.page(at: lastPageIndex) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                pdfView.go(to: page)
                print("Restored page: \(lastPageIndex + 1) for \(documentURL.lastPathComponent)")
            }
        }
    }

    class Coordinator {
        var lastOpenedURL: URL?  
    }
}
