//
//  AppAssembly.swift
//  Placebo25_test_task
//
//  Created by Dmitry on 26.01.2025.
//

import Foundation


final class AppAssembly {
    
    func assembleProfileScreen() -> ProfileViewController {
        let userDefaultsManager = UserDefaultsManager()
        let viewModel = ProfileViewModel(storage: userDefaultsManager)
        let vc = ProfileViewController(viewModel: viewModel)
        let view = ProfileView(controller: vc)
        vc.profileView = view
        return vc
    }
}
