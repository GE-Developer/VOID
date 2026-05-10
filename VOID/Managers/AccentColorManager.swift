//
//  AccentColorManager.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUICore

@Observable
final class AccentColorManager {
    
    enum ColorName: String, CaseIterable, Identifiable {
        case midnightBlue
        case solarFlare
        case neonLime
        case victoria
        case caramelRoast
        case arcticCyan
        case cosmicPurple
        case infernoRed
        
        var id: String { self.rawValue }
        
        var name: String {
            switch self {
            case .midnightBlue: "Midnight Blue"
            case .solarFlare: "Solar Flare"
            case .neonLime: "Neon Lime"
            case .victoria: "Victoria"
            case .caramelRoast: "Caramel Roast"
            case .arcticCyan: "Arctic Cyan"
            case .cosmicPurple: "Cosmic Purple"
            case .infernoRed: "Inferno Red"
            }
        }
        
        var color: Color {
            switch self {
            case .midnightBlue:
                Color("Midnight Blue (Accent)")
            case .solarFlare:
                Color("Solar Flare (Accent)")
            case .neonLime:
                Color("Neon Lime (Accent)")
            case .victoria:
                Color("Victoria (Accent)")
            case .caramelRoast:
                Color("Caramel Roast (Accent)")
            case .arcticCyan:
                Color("Arctic Cyan (Accent)")
            case .cosmicPurple:
                Color("Cosmic Purple (Accent)")
            case .infernoRed:
                Color("Inferno Red (Accent)")
            }
        }
        
        var gradient: LinearGradient {
            switch self {
            case .midnightBlue:
                LinearGradient(
                    colors: [
                        Color("Midnight Blue (Accent Gradient)"),
                        Color("Midnight Blue (Accent)")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .solarFlare:
                LinearGradient(
                    colors: [
                        Color("Solar Flare (Accent Gradient)"),
                        Color("Solar Flare (Accent)")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .neonLime:
                LinearGradient(
                    colors: [
                        Color("Neon Lime (Accent Gradient)"),
                        Color("Neon Lime (Accent)")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .victoria:
                LinearGradient(
                    colors: [
                        Color("Victoria (Accent Gradient)"),
                        Color("Victoria (Accent)")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .caramelRoast:
                LinearGradient(
                    colors: [
                        Color("Caramel Roast (Accent Gradient)"),
                        Color("Caramel Roast (Accent)")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .arcticCyan:
                LinearGradient(
                    colors: [
                        Color("Arctic Cyan (Accent Gradient)"),
                        Color("Arctic Cyan (Accent)")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .cosmicPurple:
                LinearGradient(
                    colors: [
                        Color("Cosmic Purple (Accent Gradient)"),
                        Color("Cosmic Purple (Accent)")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .infernoRed:
                LinearGradient(
                    colors: [
                        Color("Inferno Red (Accent Gradient)"),
                        Color("Inferno Red (Accent)")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        }
        
        var requiresPremium: Bool {
            switch self {
            case .midnightBlue:
                false
            case .solarFlare,
                    .neonLime,
                    .victoria,
                    .caramelRoast,
                    .arcticCyan,
                    .cosmicPurple,
                    .infernoRed:
                true
            }
        }
    }
    
    var currentColor: ColorName {
        didSet {
            defaults.set(currentColor.id, forKey: key)
        }
    }
    
    static let shared = AccentColorManager()
    
    private let defaults = UserDefaults.standard
    private let key = AppStorageKey.accentColor.key
    
    private init() {
        let savedValue = defaults.string(forKey: key)
        currentColor = ColorName(rawValue: savedValue ?? "") ?? .midnightBlue
    }
}
