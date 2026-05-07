//
//  QRCodeCustomizationView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI
import PhotosUI

struct QRCodeCustomizationView: View {
    @State private var vm: QRCodeCustomizationViewModel

    init(mainVM: QRCodeGeneratorViewModel) {
        _vm = State(initialValue: QRCodeCustomizationViewModel(mainVM: mainVM))
    }

    private var pixelStyleBinding: Binding<QRPixelStyle> {
        Binding(
            get: { vm.pixelStyle },
            set: { vm.pixelStyle = $0 }
        )
    }

    private var foregroundFillTypeBinding: Binding<FillType> {
        Binding(
            get: { vm.foregroundFillType },
            set: { newValue in withAnimation { vm.foregroundFillType = newValue } }
        )
    }

    private var foregroundFirstColorBinding: Binding<CGColor> {
        Binding(
            get: { vm.foregroundColor },
            set: { vm.foregroundColor = $0 }
        )
    }

    private var foregroundSecondColorBinding: Binding<CGColor> {
        Binding(
            get: { vm.foregroundGradientColor },
            set: { vm.foregroundGradientColor = $0 }
        )
    }

    private var eyeStyleBinding: Binding<QREyeStyle> {
        Binding(
            get: { vm.eyeStyle },
            set: { vm.eyeStyle = $0 }
        )
    }

    private var isEyeColorCustomBinding: Binding<Bool> {
        Binding(
            get: { vm.isEyeColorCustom },
            set: { vm.isEyeColorCustom = $0 }
        )
    }

    private var eyeColorBinding: Binding<CGColor> {
        Binding(
            get: { vm.eyeColor },
            set: { vm.eyeColor = $0 }
        )
    }

    private var isEyeBackgroundColorCustomBinding: Binding<Bool> {
        Binding(
            get: { vm.isEyeBackgroundColorCustom },
            set: { vm.isEyeBackgroundColorCustom = $0 }
        )
    }

    private var eyeBackgroundColorBinding: Binding<CGColor> {
        Binding(
            get: { vm.eyeBackgroundColor },
            set: { vm.eyeBackgroundColor = $0 }
        )
    }

    private var pupilStyleBinding: Binding<QRPupilStyle> {
        Binding(
            get: { vm.pupilStyle },
            set: { vm.pupilStyle = $0 }
        )
    }

    private var isPupilColorCustomBinding: Binding<Bool> {
        Binding(
            get: { vm.isPupilColorCustom },
            set: { vm.isPupilColorCustom = $0 }
        )
    }

    private var pupilColorBinding: Binding<CGColor> {
        Binding(
            get: { vm.pupilColor },
            set: { vm.pupilColor = $0 }
        )
    }

    private var backgroundFillTypeBinding: Binding<FillType> {
        Binding(
            get: { vm.backgroundFillType },
            set: { newValue in withAnimation { vm.backgroundFillType = newValue } }
        )
    }

    private var backgroundFirstColorBinding: Binding<CGColor> {
        Binding(
            get: { vm.backgroundColor },
            set: { vm.backgroundColor = $0 }
        )
    }

    private var backgroundSecondColorBinding: Binding<CGColor> {
        Binding(
            get: { vm.backgroundGradientColor },
            set: { vm.backgroundGradientColor = $0 }
        )
    }

    private var backgroundCornerRadiusBinding: Binding<CGFloat> {
        Binding(
            get: { vm.backgroundCornerRadius },
            set: { vm.backgroundCornerRadius = $0 }
        )
    }

    private var offPixelStyleBinding: Binding<QRPixelStyle> {
        Binding(
            get: { vm.offPixelStyle },
            set: { vm.offPixelStyle = $0 }
        )
    }

    private var offPixelsFillTypeBinding: Binding<FillType> {
        Binding(
            get: { vm.offPixelsFillType },
            set: { newValue in withAnimation { vm.offPixelsFillType = newValue } }
        )
    }

    private var offPixelsFirstColorBinding: Binding<CGColor> {
        Binding(
            get: { vm.offPixelsColor },
            set: { vm.offPixelsColor = $0 }
        )
    }

    private var offPixelsSecondColorBinding: Binding<CGColor> {
        Binding(
            get: { vm.offPixelsGradientColor },
            set: { vm.offPixelsGradientColor = $0 }
        )
    }

    private var negatedOnPixelsOnlyBinding: Binding<Bool> {
        Binding(
            get: { vm.negatedOnPixelsOnly },
            set: { vm.negatedOnPixelsOnly = $0 }
        )
    }

    var body: some View {
        CustomScrollView(title: vm.title) {
            EmptyView()
        } content: { _ in
            VStack(spacing: 24) {
                qrPreview
                // contrastWarning
                pixelStyleSection
                eyeStyleSection
                pupilStyleSection
                offPixelsSection
                backgroundSection
                CustomForm(headerText: vm.cornerRadiusHeader) {
                    Slider(value: backgroundCornerRadiusBinding, in: 0...1)
                        .tint(Gradient.accent)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                }
            }
        }
    }
}

// MARK: - Sections
extension QRCodeCustomizationView {
    private var qrPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color.void.accentLight, radius: 4)

            if let cgImage = vm.qrImage {
                Image(decorative: cgImage, scale: 1)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .padding()
                    .drawingGroup()
            } else {
                Image.system.qrCode
                    .font(.largeTitle)
                    .foregroundStyle(Color.void.secondaryText)
                    .opacity(0.3)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 50)
    }
    
    private var pixelStyleSection: some View {
        VStack(spacing: 16) {
            CustomCapsulePicker(
                selection: pixelStyleBinding,
                title: vm.pixelStyleHeader,
                capsuleName: { $0.name }
            )
            CustomCapsulePicker(
                selection: foregroundFillTypeBinding,
                capsuleName: { $0.name }
            )
            CustomForm {
                ColorPicker(
                    vm.colorRowTitle,
                    selection: foregroundFirstColorBinding,
                    supportsOpacity: true
                )
                .padding(.horizontal)
                .padding(.vertical, 12)

                if vm.foregroundFillType != .solid {
                    Divider()
                        .padding(.leading)
                    ColorPicker(
                        vm.gradientColorRowTitle,
                        selection: foregroundSecondColorBinding,
                        supportsOpacity: true
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
            }
        }
    }

    private var eyeStyleSection: some View {
        VStack(spacing: 16) {
            CustomCapsulePicker(
                selection: eyeStyleBinding,
                title: vm.eyeStyleHeader,
                capsuleName: { $0.name }
            )
            CustomForm {
                CustomToggleRow(
                    isOn: isEyeColorCustomBinding,
                    title: vm.customColorToggleTitle
                )

                if vm.isEyeColorCustom {
                    Divider()
                        .padding(.leading)
                    ColorPicker(
                        vm.colorRowTitle,
                        selection: eyeColorBinding,
                        supportsOpacity: true
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
            }
            CustomForm {
                CustomToggleRow(
                    isOn: isEyeBackgroundColorCustomBinding,
                    title: vm.customColorToggleTitle
                )

                if vm.isEyeBackgroundColorCustom {
                    Divider()
                        .padding(.leading)
                    ColorPicker(
                        vm.colorRowTitle,
                        selection: eyeBackgroundColorBinding,
                        supportsOpacity: true
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
            }
        }
    }

    private var pupilStyleSection: some View {
        VStack(spacing: 16) {
            CustomCapsulePicker(
                selection: pupilStyleBinding,
                title: vm.pupilStyleHeader,
                capsuleName: { $0.name }
            )
            CustomForm {
                CustomToggleRow(
                    isOn: isPupilColorCustomBinding,
                    title: vm.customColorToggleTitle
                )

                if vm.isPupilColorCustom {
                    Divider()
                        .padding(.leading)
                    ColorPicker(
                        vm.colorRowTitle,
                        selection: pupilColorBinding,
                        supportsOpacity: true
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
            }
        }
    }

    private var offPixelsSection: some View {
        VStack(spacing: 16) {
            CustomCapsulePicker(
                selection: offPixelStyleBinding,
                title: vm.offPixelsHeader,
                capsuleName: { $0.name }
            )
            CustomCapsulePicker(
                selection: offPixelsFillTypeBinding,
                capsuleName: { $0.name }
            )
            CustomForm {
                ColorPicker(
                    vm.colorRowTitle,
                    selection: offPixelsFirstColorBinding,
                    supportsOpacity: true
                )
                .padding(.horizontal)
                .padding(.vertical, 12)

                if vm.offPixelsFillType != .solid {
                    Divider()
                        .padding(.leading)
                    ColorPicker(
                        vm.gradientColorRowTitle,
                        selection: offPixelsSecondColorBinding,
                        supportsOpacity: true
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }

                Divider()
                    .padding(.leading)
                CustomToggleRow(
                    isOn: negatedOnPixelsOnlyBinding,
                    title: vm.negatedToggleTitle
                )
            }
        }
    }

    private var backgroundSection: some View {
        VStack(spacing: 16) {
            CustomCapsulePicker(
                selection: backgroundFillTypeBinding,
                title: vm.backgroundHeader,
                capsuleName: { $0.name }
            )
            CustomForm {
                ColorPicker(
                    vm.colorRowTitle,
                    selection: backgroundFirstColorBinding,
                    supportsOpacity: true
                )
                .padding(.horizontal)
                .padding(.vertical, 12)

                if vm.backgroundFillType != .solid {
                    Divider()
                        .padding(.leading)
                    ColorPicker(
                        vm.gradientColorRowTitle,
                        selection: backgroundSecondColorBinding,
                        supportsOpacity: true
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
            }
        }
    }
}
