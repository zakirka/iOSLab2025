//
//  Actor_based_CacheTests.swift
//  Actor‑based CacheTests
//
//  Created by Azamat Zakirov on 19.04.2026.
//

import Testing
@testable import Actor_based_Cache

@MainActor
struct Actor_based_CacheTests {

    @Test func testMockLoadingSuccess() async throws {

        let mock = MockUserService()
        mock.shouldReturnEmpty = false
        mock.shouldThrowError = false
        let users = try await mock.fetchUsers()
        
        #expect(users.count == 1)
        #expect(users.first?.name == "Azamat")
    }
    
    @Test func testEmptyState() async throws {
        let mock = MockUserService()
        mock.shouldReturnEmpty = true
        
        let users = try await mock.fetchUsers()
        
        #expect(users.isEmpty)
    }

    @Test func testLoadingError() async throws {
        let mock = MockUserService()
        mock.shouldThrowError = true
        
        await #expect(throws: Error.self) {
            try await mock.fetchUsers()
        }
    }
    
    
}
