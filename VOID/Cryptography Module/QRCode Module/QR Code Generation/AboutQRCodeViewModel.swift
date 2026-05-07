//
//  AboutQRCodeViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

struct AboutQRCodeViewModel: DetailedInformationProtocol {
    let title = "About"
    let subtitle = "QR Code"

    let firstTitle = "What is this tool?"
    let firstDescription = "VOID's QR Code generator turns everyday content — plain text, links, Wi-Fi credentials, contact cards, emails, phone numbers, SMS messages and map locations — into scannable QR codes that any modern camera app can read instantly."

    let secondTitle: String? = "How does it work?"
    let secondDescription: String? = "Your input is formatted into the standard payload for the chosen data type (URL, vCard, MECARD-style Wi-Fi, mailto, geo, etc.) and rendered into a QR matrix on-device. Nothing is uploaded — generation happens entirely offline, so your data never leaves your iPhone."

    let thirdTitle: String? = "Error correction"
    let thirdDescription: String? = "QR codes carry built-in redundancy so they remain readable even when partially damaged, dirty or covered by a logo. You can choose between Low, Medium, Quartile and High levels — higher correction restores more of the code but reduces the maximum amount of data you can encode."

    let fourthTitle: String? = "Customization"
    let fourthDescription: String? = "Adjust pixel and eye shapes, foreground and background colors or gradients, corner radius, quiet zone and even embed your own logo in the center. The code stays scannable as long as the contrast and quiet zone are preserved."

    let fifthTitle: String? = "Tips"
    let fifthDescription: String? = "Keep dark modules on a light background for the best scan rate, leave a clear margin around the code, and avoid shrinking it below ~2 cm when printed. If a code refuses to scan after heavy customization, raise the error correction level or simplify the styling."

    let letterType: LetterType = .binary
}
