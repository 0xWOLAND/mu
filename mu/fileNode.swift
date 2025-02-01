//
//  fileNode.swift
//  mu
//
//  Created by Bhargav Annem on 2/1/25.
//


import Foundation
import UniformTypeIdentifiers

class FileNode: Identifiable, ObservableObject {
    let id = UUID()
    let url: URL
    var children: [FileNode]?

    var isFolder: Bool { children != nil }

    init(url: URL, children: [FileNode]? = nil) {
        self.url = url
        self.children = children
    }

    /// Recursively loads PDF files from a directory
    static func loadPDFs(from url: URL) -> FileNode {
        let fileManager = FileManager.default
        var children: [FileNode] = []
        
        if let contents = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) {
            for item in contents {
                var isDirectory: ObjCBool = false
                if fileManager.fileExists(atPath: item.path, isDirectory: &isDirectory) {
                    if isDirectory.boolValue {
                        let subNode = loadPDFs(from: item)
                        if !subNode.children!.isEmpty { // Only add folders that contain PDFs
                            children.append(subNode)
                        }
                    } else if item.pathExtension.lowercased() == "pdf" {
                        children.append(FileNode(url: item))
                    }
                }
            }
        }
        
        return FileNode(url: url, children: children.isEmpty ? nil : children)
    }
}
