//
//  QRCodeAnalysisManager.swift
//  VOID
//
//  Created by GE-Developer
//

import CoreGraphics
import CoreImage
import Vision

enum QRScanQuality {
    case good
    case suspicious
    case critical
    
    var description: String {
        switch self {
        case .good:
            return L10n("QRCode.Quality.good")
        case .suspicious:
            return L10n("QRCode.Quality.suspicious")
        case .critical:
            return L10n("QRCode.Quality.critical")
        }
    }
}

struct QRCodeAnalysisService {
    private static let ciContext = CIContext(options: [.cacheIntermediates: false])

    static func analyze(_ image: CGImage) async -> QRScanQuality {
        await Task.detached(priority: .userInitiated) {
            let fullDecoded = decode(image)
            guard fullDecoded else { return QRScanQuality.critical }

            guard let degraded = degrade(image) else { return QRScanQuality.good }

            let degradedDecoded = decode(degraded)
            return degradedDecoded ? QRScanQuality.good : QRScanQuality.suspicious
        }.value
    }

    private static func decode(_ image: CGImage) -> Bool {
        let request = VNDetectBarcodesRequest()
        request.symbologies = [.qr]

        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            return false
        }

        return request.results?.contains {
            $0.symbology == .qr && ($0.payloadStringValue?.isEmpty == false)
        } ?? false
    }

    private static func degrade(_ image: CGImage) -> CGImage? {
        let target: CGFloat = 120
        let ciImage = CIImage(cgImage: image)
        let scale = target / max(CGFloat(image.width), CGFloat(image.height))
        
        let scaled = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        let blurred = scaled
            .clampedToExtent()
            .applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: 1.2])
            .cropped(to: scaled.extent)
        
        return ciContext.createCGImage(blurred, from: blurred.extent)
    }
}
