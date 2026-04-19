//
//  ProfileRepresentable.swift
//  Actor‑based Cache
//
//  Created by Azamat Zakirov on 19.04.2026.
//

import SwiftUI

struct ProfileRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = ProfileViewController
    
    func makeUIViewController(context: Context) -> ProfileViewController {
        let service = UserService()
        let viewController = ProfileViewController(userService: service)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ProfileViewController, context: Context) {
        
    }
}
