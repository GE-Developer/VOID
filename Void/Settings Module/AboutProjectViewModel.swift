//
//  AboutProjectViewModel.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct AboutProjectViewModel {
    let title = "Project"
    
    let aboutProjectTitle = "About VOID Project"
    let aboutProjectDescription = ""
    
    let sourseCodeTitle = "Source Code"
    let gitHubButtonTitle = "VOID Project"
    let gitHubButtonSubtitle = "Open on GitHub"
    
    let developersTitle = "Developers"
    let developerMichaelButtonTitle = "iOS Developer"
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
