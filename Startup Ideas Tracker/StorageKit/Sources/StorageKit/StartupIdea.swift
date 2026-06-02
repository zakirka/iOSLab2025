// MARK: - Startup Idea Model

import Foundation
import SwiftData

// MARK: - Idea Status
public enum IdeaStatus: String, Codable, CaseIterable, Identifiable {
    case new = "Новая"
    case inProgress = "В работе"
    case completed = "Завершена"
    case abandoned = "Отменена"
    
    public var id: Self { self }
}

// MARK: - Idea Priority
public enum IdeaPriority: String, Codable, CaseIterable, Identifiable {
    case low = "Низкий"
    case medium = "Средний"
    case high = "Высокий"
    
    public var id: Self { self }
}

// MARK: - Startup Idea Entity
@Model
public final class StartupIdea {
    
    // MARK: - Properties
    public var id: UUID
    public var title: String
    public var problem: String
    public var solution: String
    public var audience: String
    public var monetization: String
    public var rating: Int
    public var isFavorite: Bool
    public var status: IdeaStatus
    public var priority: IdeaPriority
    
    // MARK: - Initialization
    public init(title: String, problem: String, solution: String, audience: String = "", monetization: String = "", rating: Int = 0, isFavorite: Bool = false, status: IdeaStatus = .new, priority: IdeaPriority = .medium) {
        self.id = UUID()
        self.title = title
        self.problem = problem
        self.solution = solution
        self.audience = audience
        self.monetization = monetization
        self.rating = rating
        self.isFavorite = isFavorite
        self.status = status
        self.priority = priority
    }
    
    // MARK: - Export Utility
    public func exportToMarkdown() -> String {
        return """
        # \(title)
        
        **Статус:** \(status.rawValue)
        **Приоритет:** \(priority.rawValue)
        **Оценка:** \(rating) / 5
        
        ## Проблема
        \(problem)
        
        ## Решение
        \(solution)
        
        ## Целевая аудитория
        \(audience.isEmpty ? "Не указана" : audience)
        
        ## Монетизация
        \(monetization.isEmpty ? "Не указана" : monetization)
        """
    }
}
