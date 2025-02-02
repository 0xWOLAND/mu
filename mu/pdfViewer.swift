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

        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(context.coordinator.handleAppClosing),
            name: NSApplication.willTerminateNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(context.coordinator.handleAppClosing),
            name: NSApplication.didResignActiveNotification,
            object: nil
        )

        context.coordinator.pdfView = pdfView
        context.coordinator.currentDocumentURL = url

        return pdfView
    }

    func updateNSView(_ nsView: PDFView, context: Context) {
        if let previousURL = context.coordinator.currentDocumentURL {
            saveCurrentPage(nsView, for: previousURL)
        }

        if let document = PDFDocument(url: url) {
            nsView.document = document
            restoreLastPage(nsView, for: url)
        }

        context.coordinator.currentDocumentURL = url
        context.coordinator.pdfView = nsView
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    private func saveCurrentPage(_ pdfView: PDFView, for documentURL: URL) {
        guard let document = pdfView.document,
              let currentPage = pdfView.currentPage else { return }

        let pageNumber = document.index(for: currentPage)

        UserDefaults.standard.set(pageNumber, forKey: documentURL.path)
        UserDefaults.standard.synchronize()
        print("Saved page: \(pageNumber + 1) for \(documentURL.lastPathComponent)")
    }

    private func restoreLastPage(_ pdfView: PDFView, for documentURL: URL) {
        guard let document = pdfView.document else { return }

        // Retrieve last saved page for this specific document
        if let lastPageIndex = UserDefaults.standard.value(forKey: documentURL.path) as? Int,
           let page = document.page(at: lastPageIndex) {
            pdfView.go(to: page)
        }
    }

    class Coordinator: NSObject {
        var pdfView: PDFView?
        var currentDocumentURL: URL?

        @objc func handleAppClosing() {
            guard let pdfView = pdfView, let documentURL = currentDocumentURL else { return }
            
            if let currentPage = pdfView.currentPage {
                let pageNumber = pdfView.document?.index(for: currentPage) ?? 0
                UserDefaults.standard.set(pageNumber, forKey: documentURL.path)
                UserDefaults.standard.synchronize()
                print("Saved last page before closing: \(pageNumber + 1) for \(documentURL.lastPathComponent)")
            }
        }
    }
}
