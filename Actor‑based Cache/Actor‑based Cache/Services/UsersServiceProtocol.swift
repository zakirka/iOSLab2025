//
//  UsersServiceProtocol.swift
//  Actor‑based Cache
//
//  Created by Azamat Zakirov on 19.04.2026.
//

import Foundation

protocol UsersServiceProtocol {
    func fetchUsers() async throws -> [User]
}
