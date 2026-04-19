//
//  MockUserService.swift
//  Actor‑based Cache
//
//  Created by Azamat Zakirov on 19.04.2026.
//

import Foundation

class MockUserService: UsersServiceProtocol {
    var shouldReturnEmpty = false
    var shouldThrowError = false
    func fetchUsers() async throws -> [User] {
        if shouldReturnEmpty {
            return []
        }
        if shouldThrowError {
            throw NSError(domain: "Network", code: -1)
        }
        return [User(id: 1, name: "Azamat", username: "Azamat", email: "Azamat@example.com")]
    }
}
