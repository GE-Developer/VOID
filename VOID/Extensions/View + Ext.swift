//
//  View + Ext.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

// MARK: - View Extension
extension View {
    var logo: some View {
        Image.other.svgLogo
            .resizable()
            .scaledToFit()
    }
    
    var isFaceIDPhone: Bool {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            return false
        }
        return window.safeAreaInsets.bottom > 0
    }
    
    func getHeight(_ height: Binding<Double>) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { height.wrappedValue = geo.size.height }
            }
        )
    }
    
    func premiumOption(
        _ showPayWall: Binding<Bool>,
        swipable: Bool = false,
        isIncluded: Bool = true
    ) -> some View {
        self.modifier(
            PremiumLockModifier(showPayWall, swipable: swipable, isIncluded: isIncluded)
        )
    }
    
    func screenshotDisabled(_ isEnabled: Bool) -> some View {
        ZStack {
            if isEnabled {
                VStack {
                    logo
                        .frame(height: 50)
                    Text("Secured")
                        .font(.headline)
                        .fontDesign(.monospaced)
                        .foregroundStyle(Color.void.mainText)
                }
            }
            self.mask {
                if isEnabled {
                    ScreenShotPreventerMask()
                        .ignoresSafeArea()
                } else {
                    Color.white
                        .ignoresSafeArea()
                }
            }
            .animation(nil, value: isEnabled)
        }
    }
}

// MARK: - View Modifiers
struct PremiumLockModifier: ViewModifier {
    @EnvironmentObject private var store: StoreManager
    @Binding private var showPayWall: Bool
    
    private let swipable: Bool
    private let isIncluded: Bool
    
    init(_ showPayWall: Binding<Bool>, swipable: Bool, isIncluded: Bool) {
        self._showPayWall = showPayWall
        self.swipable = swipable
        self.isIncluded = isIncluded
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if isIncluded {
            content
                .opacity(store.isPremium ? 1 : 0.5)
                .disabled(!store.isPremium)
                .overlay {
                    if swipable {
                        swipableOverlay
                    } else {
                        notSwipableOverlay
                    }
                }
        } else {
            content
        }
    }
    
    @ViewBuilder
    private var swipableOverlay: some View {
        if !store.isPremium {
            Color.void.blackAndWhite.opacity(0.000001)
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { value in
                            if value.translation.width > 50
                                && abs(value.translation.height) < 30 {
                                showPayWall = true
                            }
                        }
                )
                .onTapGesture {
                    showPayWall = true
                }
        }
    }
    
    @ViewBuilder
    private var notSwipableOverlay: some View {
        if !store.isPremium {
            Color.void.blackAndWhite.opacity(0.000001)
                .onTapGesture {
                    showPayWall = true
                }
        }
    }
}

// MARK: - ScreenShot Preventer Mask
struct ScreenShotPreventerMask: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UITextField()
        view.isSecureTextEntry = true
        view.text = ""
        view.isUserInteractionEnabled = false
        
        if let autoHideLayer = findAutoHideLayer(view: view) {
            autoHideLayer.backgroundColor = UIColor.white.cgColor
        } else {
            view.layer.sublayers?.last?.backgroundColor = UIColor.white.cgColor
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    func findAutoHideLayer(view: UIView) -> CALayer? {
        if let layers = view.layer.sublayers {
            if let layer = layers.first(where: { layer in
                layer.delegate.debugDescription.contains("UITextLayoutCanvasView")
            }) {
                return layer
            }
        }
        
        return nil
    }
}
