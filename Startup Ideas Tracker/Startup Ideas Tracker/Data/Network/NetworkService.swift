// MARK: - Network Service

import Foundation

// MARK: - Network Error
enum NetworkError: Error {
    case badURL
    case badStatusCode(Int)
    case decodingError
    case unknown
}

// MARK: - Data Transfer Objects (DTO)
struct QuoteDTO: Codable {
    let id: Int
    let quote: String
    let author: String
}

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func fetchRandomIdeaInspiration() async throws -> QuoteDTO
}

// MARK: - Idea Generator Service Implementation
final class IdeaGeneratorService: NetworkServiceProtocol {
    
    // MARK: - Fetch Inspiration
    func fetchRandomIdeaInspiration() async throws -> QuoteDTO {
        guard let url = URL(string: "https://dummyjson.com/quotes/random") else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }
        
        do {
            let quote = try JSONDecoder().decode(QuoteDTO.self, from: data)
            return quote
        } catch {
            throw NetworkError.decodingError
        }
    }
}
