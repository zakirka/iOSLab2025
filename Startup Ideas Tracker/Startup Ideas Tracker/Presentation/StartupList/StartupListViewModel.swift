// MARK: - Startup List ViewModel

import Foundation
import Observation
import StorageKit

// MARK: - View States
public enum ViewState {
    case loading
    case empty
    case content
    case error(String)
}

// MARK: - ViewModel Implementation
@MainActor
@Observable
final class StartupListViewModel {
    
    // MARK: - Dependencies
    private let storage: StartupStorageService 
    
    // MARK: - Private State
    private var allIdeas: [StartupIdea] = []
    
    // MARK: - Published Properties
    public var searchText: String = ""
    public var state: ViewState = .loading
    
    // MARK: - Computed Properties
    public var ideas: [StartupIdea] {
        if searchText.isEmpty {
            return allIdeas
        } else {
            return allIdeas.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) || 
                $0.problem.localizedCaseInsensitiveContains(searchText) 
            }
        }
    }
    
    // MARK: - Initialization
    public init(storage: StartupStorageService) {
        self.storage = storage
    }
    
    // MARK: - Data Management Actions
    func load() async {
        state = .loading
        do {
            self.allIdeas = try await storage.fetchIdeas()
            state = allIdeas.isEmpty ? .empty : .content
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func delete(idea: StartupIdea) {
        Task {
            do {
                try await storage.delete(idea: idea)
                if let index = self.allIdeas.firstIndex(where: { $0.id == idea.id }) {
                    self.allIdeas.remove(at: index)
                }
                if self.allIdeas.isEmpty {
                    self.state = .empty
                }
            } catch {
                self.state = .error(error.localizedDescription)
            }
        }
    }
}
