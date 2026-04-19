//
//  User.swift
//  Actor‑based Cache
//
//  Created by Azamat Zakirov on 18.04.2026.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
