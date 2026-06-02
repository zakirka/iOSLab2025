// MARK: - Mock Storage Service

import Foundation

// MARK: - Mock Implementation
public final class MockStorageService: StartupStorageService {

    // MARK: - Properties
    private var mockIdeas: [StartupIdea] = []
    public var shouldThrowError = false
    
    // MARK: - Initialization
    public init(initialIdeas: [StartupIdea] = []) {
        self.mockIdeas = initialIdeas
    }
    
    // MARK: - Service Methods
    public func fetchIdeas() async throws -> [StartupIdea] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test mock error"])
        }
        return mockIdeas
    }
    
    public func save(idea: StartupIdea) async throws {
        mockIdeas.append(idea)
    }
    
    public func delete(idea: StartupIdea) async throws {
        mockIdeas.removeAll { $0.id == idea.id }
    }
}
