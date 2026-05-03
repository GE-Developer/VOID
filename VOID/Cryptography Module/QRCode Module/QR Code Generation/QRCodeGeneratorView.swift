//
//  QRCodeGeneratorView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI
import MapKit

struct QRCodeGeneratorView: View {
    @StateObject private var vm = QRCodeGeneratorViewModel()
    
    private var plainTextBinding: Binding<String> {
        Binding(
            get: { vm.text },
            set: { vm.text = vm.trimToByteLimit($0) }
        )
    }

    private var urlSchemeBinding: Binding<String> {
        Binding(
            get: { vm.selectedURLScheme.rawValue },
            set: { vm.selectedURLScheme = .init(rawValue: $0) ?? .http }
        )
    }

    private var urlBinding: Binding<String> {
        Binding(
            get: { vm.url },
            set: { vm.url = vm.sanitize(text: $0, fieldType: .url) }
        )
    }

    private var wifiEncryptionBinding: Binding<String> {
        Binding(
            get: { vm.wifiEncryption.rawValue },
            set: { vm.wifiEncryption = .init(rawValue: $0) ?? .wpa }
        )
    }

    private var wifiSSIDBinding: Binding<String> {
        Binding(
            get: { vm.wifiSSID },
            set: { vm.wifiSSID = vm.sanitize(text: $0, fieldType: .ssid) }
        )
    }

    private var wifiPasswordBinding: Binding<String> {
        Binding(
            get: { vm.wifiPassword },
            set: { vm.wifiPassword = vm.sanitize(text: $0, fieldType: .ssidPassword) }
        )
    }

    private var contactNameBinding: Binding<String> {
        Binding(
            get: { vm.contactName },
            set: { vm.contactName = vm.sanitize(text: $0, fieldType: .name) }
        )
    }

    private var contactPhoneBinding: Binding<String> {
        Binding(
            get: { vm.contactPhone },
            set: { vm.contactPhone = vm.sanitize(text: $0, fieldType: .phone) }
        )
    }

    private var contactEmailBinding: Binding<String> {
        Binding(
            get: { vm.contactEmail },
            set: { vm.contactEmail = vm.sanitize(text: $0, fieldType: .email) }
        )
    }

    private var emailAddressBinding: Binding<String> {
        Binding(
            get: { vm.emailAddress },
            set: { vm.emailAddress = vm.sanitize(text: $0, fieldType: .email) }
        )
    }

    private var emailSubjectBinding: Binding<String> {
        Binding(
            get: { vm.emailSubject },
            set: { vm.emailSubject = vm.sanitize(text: $0, fieldType: .subject) }
        )
    }

    private var emailBodyBinding: Binding<String> {
        Binding(
            get: { vm.emailBody },
            set: { vm.emailBody = vm.trimToByteLimit($0) }
        )
    }

    private var phoneNumberBinding: Binding<String> {
        Binding(
            get: { vm.phoneNumber },
            set: { vm.phoneNumber = vm.sanitize(text: $0, fieldType: .phone) }
        )
    }

    private var smsNumberBinding: Binding<String> {
        Binding(
            get: { vm.smsNumber },
            set: { vm.smsNumber = vm.sanitize(text: $0, fieldType: .phone) }
        )
    }

    private var smsMessageBinding: Binding<String> {
        Binding(
            get: { vm.smsMessage },
            set: { vm.smsMessage = vm.trimToByteLimit($0) }
        )
    }
    
    private var progressColor: Color {
        switch vm.payloadFraction {
        case 0.95...: .void.errorRed
        case 0.75...: .void.tangOrange
        default:      Color.void.accentLight
        }
    }
    
    private var defaultLocationRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180)
        )
    }
    
    var body: some View {
        CustomScrollView(title: vm.title) {
            EmptyView()
        } content: { _ in
            qrCodeGeneratorView
        }
    }
}

// MARK: - Builder
extension QRCodeGeneratorView {
    private var qrCodeGeneratorView: some View {
        VStack(spacing: 24) {
            qrPreview
            errorCorrectionPicker
            dataTypePicker
            inputDataView
            payloadProgressView
        }
    }
    
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
            } else if vm.generationFailed {
                VStack(spacing: 8) {
                    Image.system.warning
                        .font(.largeTitle)
                    Text(vm.errorTitle)
                        .font(.callout)
                        .fontDesign(.rounded)
                    Text(vm.errorDescription)
                        .font(.callout)
                        .minimumScaleFactor(0.5)
                        .fontDesign(.rounded)
                }
                .foregroundStyle(Color.void.errorRed)
                .multilineTextAlignment(.center)
                .padding()
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
        .task(id: vm.stringResult) {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await vm.generate()
        }
        .onChange(of: vm.selectedErrorCorrection) {
            Task { await vm.generate() }
        }
    }

    private var errorCorrectionPicker: some View {
        CustomCapsulePicker(
            selection: $vm.selectedErrorCorrection,
            disabledItems: vm.disabledErrorCorrectionLevels,
            title: vm.errorCorrectionTitle,
            capsuleName: { $0.name }
        )
    }

    private var dataTypePicker: some View {
        CustomCapsulePicker(
            selection: $vm.selectedDataType,
            title: vm.dataTypeTitle,
            capsuleName: { $0.name }
        )
    }
    
    private var inputDataView: some View {
        VStack {
            header(text: vm.inputDataTitle)
            
            switch vm.selectedDataType {
            case .plainText:
                plainTextInput
            case .url:
                urlInput
            case .wifi:
                wifiInput
            case .contact:
                contactInput
            case .email:
                emailMessageInput
            case .phone:
                phoneInput
            case .sms:
                smsInput
            case .location:
                locationInput
            }
        }
    }
    
    @ViewBuilder
    private var payloadProgressView: some View {
        switch vm.selectedDataType {
        case .plainText:
            payloadProgressBar
        case .url:
            EmptyView()
        case .wifi:
            EmptyView()
        case .contact:
            EmptyView()
        case .email:
            payloadProgressBar
        case .phone:
            EmptyView()
        case .sms:
            payloadProgressBar
        case .location:
            EmptyView()
        }
    }

    private var plainTextInput: some View {
        VStack(spacing: 8) {
            CustomTextField(
                text: plainTextBinding,
                placeholder: vm.textPlaceholder,
                isMultilined: true
            )
        }
    }
    
    private var urlInput: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                MenuPickerView(
                    selection: urlSchemeBinding,
                    options: vm.urlSchemeOptions
                )

                CustomTextField(
                    text: urlBinding,
                    keyboard: .URL,
                    placeholder: vm.urlPlaceholder,
                    error: !vm.isUrlValid(vm.url)
                )
            }

            counterFor(vm.counter(vm.url, for: .url))
        }
    }
    
    private var wifiInput: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                MenuPickerView(
                    selection: wifiEncryptionBinding,
                    options: vm.wifiEncryptionOptions
                )

                CustomTextField(
                    text: wifiSSIDBinding,
                    placeholder: vm.wifiSSIDPlaceholder
                )
            }
            counterFor(vm.counter(vm.wifiSSID, for: .ssid))

            if vm.wifiEncryption != .open {
                CustomTextField(
                    text: wifiPasswordBinding,
                    placeholder: vm.passwordPlaceholder
                )
                counterFor(vm.counter(vm.wifiPassword, for: .ssidPassword))
            }
        }
    }
    
    private var contactInput: some View {
        VStack(spacing: 8) {
            CustomTextField(
                text: contactNameBinding,
                placeholder: vm.namePlaceholder
            )
            counterFor(vm.counter(vm.contactName, for: .name))

            CustomTextField(
                text: contactPhoneBinding,
                keyboard: .phonePad,
                placeholder: vm.phonePlaceholder,
                error: !vm.isPhoneValid(vm.contactPhone)
            )
            counterFor(vm.counter(vm.contactPhone, for: .phone))

            CustomTextField(
                text: contactEmailBinding,
                keyboard: .emailAddress,
                placeholder: vm.emailPlaceholder,
                error: !vm.isEmailValid(vm.contactEmail)
            )
            counterFor(vm.counter(vm.contactEmail, for: .email))
        }
    }

    private var emailMessageInput: some View {
        VStack(spacing: 8) {
            CustomTextField(
                text: emailAddressBinding,
                keyboard: .emailAddress,
                placeholder: vm.emailPlaceholder,
                error: !vm.isEmailValid(vm.emailAddress)
            )
            counterFor(vm.counter(vm.emailAddress, for: .email))

            CustomTextField(
                text: emailSubjectBinding,
                placeholder: vm.subjectPlaceholder
            )
            counterFor(vm.counter(vm.emailSubject, for: .subject))

            CustomTextField(
                text: emailBodyBinding,
                placeholder: vm.messagePlaceholder,
                isMultilined: true
            )
        }
    }

    private var phoneInput: some View {
        VStack(spacing: 8) {
            CustomTextField(
                text: phoneNumberBinding,
                keyboard: .phonePad,
                placeholder: vm.phonePlaceholder,
                error: !vm.isPhoneValid(vm.phoneNumber)
            )
            counterFor(vm.counter(vm.phoneNumber, for: .phone))
        }
    }

    private var smsInput: some View {
        VStack(spacing: 8) {
            CustomTextField(
                text: smsNumberBinding,
                keyboard: .phonePad,
                placeholder: vm.phonePlaceholder,
                error: !vm.isPhoneValid(vm.smsNumber)
            )
            counterFor(vm.counter(vm.smsNumber, for: .phone))

            CustomTextField(
                text: smsMessageBinding,
                placeholder: vm.messagePlaceholder,
                isMultilined: true
            )
        }
    }

    private var locationInput: some View {
        VStack(spacing: 8) {
            MapReader { proxy in
                Map(initialPosition: .region(defaultLocationRegion)) {
                    if let coordinate = vm.selectedCoordinate {
                        Marker("", coordinate: coordinate)
                    }
                }
                .onTapGesture(coordinateSpace: .local) { point in
                    if let coordinate = proxy.convert(point, from: .local) {
                        vm.selectedCoordinate = coordinate
                    }
                }
            }
            .frame(height: 240)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            counterFor(vm.coordinateDescription)
        }
    }

    private var payloadProgressBar: some View {
        VStack(spacing: 4) {
            VStack {
                header(text: vm.payloadTitle)
                ProgressView(value: vm.payloadFraction)
                    .tint(progressColor)
            }

            counterFor(vm.payloadDescription)
        }
    }

    private func counterFor(_ text: String) -> some View {
        HStack {
            Spacer()
            Text(text)
                .font(.caption2)
                .fontDesign(.rounded)
                .foregroundStyle(Color.void.secondaryText)
        }
    }
    
    private func header(text: String) -> some View {
        Text(text)
            .foregroundStyle(Color.void.mainText)
            .font(.caption)
            .fontDesign(.rounded)
            .textCase(.uppercase)
            .lineLimit(2)
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 6)
    }
}
