// MARK: - Main Application Entry

import SwiftUI
import SwiftData
import StorageKit

@main
struct Startup_Ideas_TrackerApp: App {
    
    // MARK: - Database Container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([StartupIdea.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Не удалось создать ModelContainer: \(error)")
        }
    }()
    
    // MARK: - App Scene
    var body: some Scene {
        WindowGroup {
            let storage = StorageService(modelContext: sharedModelContainer.mainContext)
            let networkService = IdeaGeneratorService()
            let inspirationUseCase = IdeaInspirationUseCase(networkService: networkService)
            let viewModel = StartupListViewModel(storage: storage)
            
            StartupListView(
                viewModel: viewModel,
                storage: storage,
                inspirationUseCase: inspirationUseCase
            )
        }
        .modelContainer(sharedModelContainer)
    }
}
