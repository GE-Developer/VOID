//
//  AboutProjectViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct AboutProjectViewModel {
    let title = L10n("Project.title")
    
    let aboutProjectTitle = L10n("Project.AboutProject.title")
    let aboutProjectDescription = L10n("Project.AboutProject.description")
    let otherInfo = L10n("Project.other")
    
    let sourseCodeTitle = L10n("Project.SourceCode.title")
    let gitHubButtonTitle = L10n("Project.SourceCode.Button.title")
    let gitHubButtonSubtitle = L10n("Project.SourceCode.Button.subtitle")
    
    let developersTitle = L10n("Project.Developers.title")
    let developerMichaelButtonTitle = L10n("Project.Developers.MichaelButton.title")
    let developerMichaelButtonSubtitle = "MICHAEL"
    
    private let gitHubURL = "https://github.com/GE-Developer/VOID"
    private let developerMichaelURL = "https://ge-developer.tilda.ws"
    
    func gitHubButtonPressed() {
        guard let url = URL(string: gitHubURL) else { return }
        UIApplication.shared.open(url)
    }
    
    func developerMichaelButtonPressed() {
        guard let url = URL(string: developerMichaelURL) else { return }
        UIApplication.shared.open(url)
    }
}
