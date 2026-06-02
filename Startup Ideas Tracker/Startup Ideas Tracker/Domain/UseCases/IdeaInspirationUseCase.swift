// MARK: - Idea Inspiration Use Case

import Foundation

// MARK: - Inspiration Data Model
struct InspirationData {
    let title: String
    let problem: String
    let solution: String
}

// MARK: - Use Case Protocol
protocol IdeaInspirationUseCaseProtocol {
    func execute() async throws -> InspirationData
}

// MARK: - Use Case Implementation
final class IdeaInspirationUseCase: IdeaInspirationUseCaseProtocol {
    
    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Execute Use Case
    func execute() async throws -> InspirationData {
        let quoteDTO = try await networkService.fetchRandomIdeaInspiration()
        return InspirationData(
            title: "Идея от \(quoteDTO.author)",
            problem: "Людям нужна мотивация.",
            solution: quoteDTO.quote
        )
    }
}
