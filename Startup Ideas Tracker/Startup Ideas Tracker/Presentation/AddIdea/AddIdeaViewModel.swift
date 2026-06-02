// MARK: - Add Idea ViewModel

import Foundation
import Observation
import StorageKit

@MainActor
@Observable
final class AddIdeaViewModel {
    
    // MARK: - Dependencies
    private let storage: StartupStorageService
    private let inspirationUseCase: IdeaInspirationUseCaseProtocol
    
    // MARK: - Published Form Properties
    var title = ""
    var problem = ""
    var solution = ""
    var audience = ""
    var monetization = ""
    var rating = 3
    var status: IdeaStatus = .new
    var priority: IdeaPriority = .medium
    
    // MARK: - Published State Properties
    var isLoadingInspiration = false
    var errorMessage: String?
    
    // MARK: - Initialization
    init(storage: StartupStorageService, inspirationUseCase: IdeaInspirationUseCaseProtocol) {
        self.storage = storage
        self.inspirationUseCase = inspirationUseCase
    }
    
    // MARK: - Use Case Executions
    func generateInspiration() async {
        isLoadingInspiration = true
        errorMessage = nil
        do {
            let data = try await inspirationUseCase.execute()
            self.title = data.title
            self.problem = data.problem
            self.solution = data.solution
        } catch {
            errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
        }
        isLoadingInspiration = false
    }
    
    func saveIdea() async throws {
        let newIdea = StartupIdea(
            title: title,
            problem: problem,
            solution: solution,
            audience: audience,
            monetization: monetization,
            rating: rating,
            status: status,
            priority: priority
        )
        try await storage.save(idea: newIdea)
    }
}
