// MARK: - Storage Protocols

import Foundation

// MARK: - Storage Service Protocol
public protocol StartupStorageService {
    func fetchIdeas() async throws -> [StartupIdea]
    func save(idea: StartupIdea) async throws
    func delete(idea: StartupIdea) async throws
}
