// MARK: - Storage Service

import SwiftData
import StorageKit

// MARK: - Storage Service Implementation
final class StorageService: StartupStorageService {
    
    // MARK: - Properties
    private var modelContext: ModelContext

    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Fetch Ideas
    func fetchIdeas() async throws -> [StartupIdea] {
        let descriptor = FetchDescriptor<StartupIdea>()
        return try modelContext.fetch(descriptor)
    }

    // MARK: - Save Idea
    func save(idea: StartupIdea) async throws {
        modelContext.insert(idea)
        try modelContext.save()
    }

    // MARK: - Delete Idea
    func delete(idea: StartupIdea) async throws {
        modelContext.delete(idea)
        try modelContext.save()
    }
}
