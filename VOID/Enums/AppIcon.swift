//
//  AppIcon.swift
//  VOID
//
//  Created by GE-Developer
//

enum AppIcon: String, CaseIterable, Identifiable {
    case blackVoid
    case ghostWhite
    case cyberGold
    case titanium
    case neonPinky
    case desertForge
    
    var id: String { rawValue.capitalized }

    var appIconid: String? {
        switch self {
        case .blackVoid:
            return nil
        case .ghostWhite:
            return "GhostWhite"
        case .cyberGold:
            return "CyberGold"
        case .titanium:
            return "Titanium"
        case .neonPinky:
            return "NeonPinky"
        case .desertForge:
            return "DesertForge"
        }
    }

    var title: String {
        switch self {
        case .blackVoid:
            return "Black VOID"
        case .ghostWhite:
            return "Ghost White"
        case .cyberGold:
            return "Cyber Gold"
        case .titanium:
            return "Titanium"
        case .neonPinky:
            return "Neon Pinky"
        case .desertForge:
            return "Desert Forge"
        }
    }

    var requiresPremium: Bool {
        switch self {
        case .blackVoid:
            false
        default:
            true
        }
    }
}
