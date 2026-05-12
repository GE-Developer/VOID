//
//  QRExportFormat.swift
//  VOID
//
//  Created by GE-Developer
//

import UniformTypeIdentifiers

enum QRExportFormat: String, CaseIterable {
    case png, pdf, svg
    
    var title: String {
        switch self {
        case .png: "PNG"
        case .pdf: "PDF"
        case .svg: "SVG"
        }
    }
    
    var fileExtension: String { rawValue }
    
    var contentType: UTType {
        switch self {
        case .png: .png
        case .pdf: .pdf
        case .svg: .svg
        }
    }
}
