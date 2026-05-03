//
//  QRCodeGeneratorManager.swift
//  VOID
//
//  Created by GE-Developer
//

import CoreGraphics
import QRCode

struct QRCodeGeneratorManager {
    // MARK: - QR Code Generation
    static func generateQRCode(
        from payload: String,
        configuration: QRCodeConfiguration,
        dimension: Int = 400
    ) async throws -> CGImage {
        try await Task.detached {

            // Step 1: Generating QR Document from payload
            let doc = try QRCode.Document(utf8String: payload)

            // Step 2: Correction level
            doc.errorCorrection = configuration.errorCorrection.qrCodeLevel

            let style = configuration.style

            // Step 3: QR pixel form
            doc.design.shape.onPixels = style.pixelStyle.generator
            doc.design.shape.eye = style.eyeStyle.generator
            doc.design.shape.pupil = style.pupilStyle.generator

            // Step 4: Off-pixels
            if let offStyle = style.offPixelStyle {
                doc.design.shape.offPixels = offStyle.generator
                doc.design.style.offPixels = makeFill(
                    type: style.offPixelsFillType,
                    color: style.offPixelsColor,
                    gradientColor: style.offPixelsGradientColor
                )
            }

            // Step 5: Negative mode
            doc.design.shape.negatedOnPixelsOnly = style.negatedOnPixelsOnly

            // Step 6: Pixel fill color
            doc.design.style.onPixels = makeFill(
                type: style.foregroundFillType,
                color: style.foregroundColor,
                gradientColor: style.foregroundGradientColor
            )

            // Step 7: Fill background
            doc.design.style.background = makeFill(
                type: style.backgroundFillType,
                color: style.backgroundColor,
                gradientColor: style.backgroundGradientColor
            )

            // Step 8: Corner radius
            doc.design.style.backgroundFractionalCornerRadius = style.backgroundCornerRadius

            // Step 9: Color for eyes and pupils
            if let eyeColor = style.eyeColor {
                doc.design.style.eye = QRCode.FillStyle.Solid(eyeColor)
            }

            if let pupilColor = style.pupilColor {
                doc.design.style.pupil = QRCode.FillStyle.Solid(pupilColor)
            }

            // Step 10: Eyes background
            doc.design.style.eyeBackground = style.eyeBackgroundColor

            // Step 11: Quiet zone
            doc.design.additionalQuietZonePixels = UInt(configuration.quietZone) + configuration.additionalQuietZonePixels

            // Step 12: Logo adding
            if let logo = style.logoImage {
                let maxSize: CGFloat = 0.30
                let aspect = CGFloat(logo.width) / CGFloat(logo.height)

                let w: CGFloat
                let h: CGFloat
                
                if aspect > 1 {
                    w = maxSize
                    h = maxSize / aspect
                } else {
                    h = maxSize
                    w = maxSize * aspect
                }

                let x = (1 - w) / 2
                let y = (1 - h) / 2
                
                doc.logoTemplate = QRCode.LogoTemplate(
                    image: logo,
                    path: CGPath(
                        rect: CGRect(x: x, y: y, width: w, height: h),
                        transform: nil
                    ),
                    inset: 4
                )
            }
            
            // Step 13: QR Code generation
            return try doc.cgImage(dimension: dimension)
        }.value
    }

    // MARK: - Payload Setup
    static func formatPayload(
        type: QRDataType,
        text: String = "",
        url: String = "",
        wifiSSID: String = "",
        wifiPassword: String = "",
        wifiEncryption: String = "WPA",
        contactName: String = "",
        contactPhone: String = "",
        contactEmail: String = "",
        emailAddress: String = "",
        emailSubject: String = "",
        emailBody: String = "",
        phoneNumber: String = "",
        smsNumber: String = "",
        smsMessage: String = "",
        latitude: String = "",
        longitude: String = ""
    ) -> String {
        switch type {
        case .plainText:
            return text
        case .url:
            return url
        case .wifi:
            return formatWiFi(
                ssid: wifiSSID,
                password: wifiPassword,
                encryption: wifiEncryption
            )
        case .contact:
            return formatVCard(
                name: contactName,
                phone: contactPhone,
                email: contactEmail
            )
        case .email:
            return formatEmail(
                address: emailAddress,
                subject: emailSubject,
                body: emailBody
            )
        case .phone:
            return "tel:\(phoneNumber)"
        case .sms:
            return formatSMS(number: smsNumber, message: smsMessage)
        case .location:
            return "geo:\(latitude),\(longitude)"
        }
    }

    // MARK: - Fill Method
    private static func makeFill(
        type: FillType,
        color: CGColor,
        gradientColor: CGColor
    ) -> any QRCodeFillStyleGenerator {
        switch type {
        case .solid:
            return QRCode.FillStyle.Solid(color)

        case .linearGradient:
            do {
                let gradient = try DSFGradient(
                    pins: [
                        DSFGradient.Pin(color, 0),
                        DSFGradient.Pin(gradientColor, 1)
                    ]
                )
                return QRCode.FillStyle.LinearGradient(gradient)
            } catch {
                return QRCode.FillStyle.Solid(color)
            }

        case .radialGradient:
            do {
                let gradient = try DSFGradient(pins: [
                    DSFGradient.Pin(color, 0),
                    DSFGradient.Pin(gradientColor, 1)
                ])
                return QRCode.FillStyle.RadialGradient(gradient)
            } catch {
                return QRCode.FillStyle.Solid(color)
            }
        }
    }

    // MARK: - Format Wi-Fi Method
    private static func formatWiFi(
        ssid: String,
        password: String,
        encryption: String
    ) -> String {
        let escapedSSID = escapeSpecialCharacters(ssid)
        let escapedPassword = escapeSpecialCharacters(password)
        
        return "WIFI:T:\(encryption);S:\(escapedSSID);P:\(escapedPassword);;"
    }
    
    private static func escapeSpecialCharacters(_ string: String) -> String {
        string
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: ";", with: "\\;")
            .replacingOccurrences(of: ",", with: "\\,")
            .replacingOccurrences(of: ":", with: "\\:")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
    
    // MARK: - Format Contact Card Method
    private static func formatVCard(
        name: String,
        phone: String,
        email: String
    ) -> String {
        var components = ["BEGIN:VCARD", "VERSION:3.0"]
        
        if !name.isEmpty {
            components.append("FN:\(name)")
        }
        
        if !phone.isEmpty {
            components.append("TEL:\(phone)")
        }
        
        if !email.isEmpty {
            components.append("EMAIL:\(email)")
        }
        
        components.append("END:VCARD")

        return components.joined(separator: "\n")
    }

    // MARK: - Format Email Method
    private static func formatEmail(
        address: String,
        subject: String,
        body: String
    ) -> String {
        var result = "mailto:\(address)"
        var params: [String] = []
        
        if !subject.isEmpty {
            params.append("subject=\(percentEncode(subject))")
        }
        
        if !body.isEmpty {
            params.append("body=\(percentEncode(body))")
        }
        

        if !params.isEmpty {
            result += "?" + params.joined(separator: "&")
        }
        
        return result
    }
    
    private static func percentEncode(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }

    // MARK: - Format SMS Method
    private static func formatSMS(number: String, message: String) -> String {
        if message.isEmpty {
            return "smsto:\(number)"
        }
        
        return "smsto:\(number):\(message)"
    }
}
