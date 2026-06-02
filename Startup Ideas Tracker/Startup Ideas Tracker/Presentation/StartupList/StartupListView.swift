// MARK: - Startup List View

import SwiftUI
import StorageKit

// MARK: - View Structure
struct StartupListView: View {
    
    // MARK: - State & Dependencies
    @Bindable var viewModel: StartupListViewModel
    @State private var isShowingAddSheet = false
    
    let storage: StartupStorageService
    let inspirationUseCase: IdeaInspirationUseCaseProtocol
    
    // MARK: - UI Body
    var body: some View {
        NavigationStack {
            Group {
                contentForState
            }
            .navigationTitle(Text("Список идей"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                addIdeaSheet
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Поиск идей...")
        .task {
            await viewModel.load()
        }
    }
    
    // MARK: - UI Components
    @ViewBuilder
    private var contentForState: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Загрузка...")
        case .empty:
            ContentUnavailableView("Идей пока нету", systemImage: "lightbulb")
        case .content:
            ideasListView
        case .error(let message):
            Text("Ошибка: \(message)")
        }
    }
    
    private var ideasListView: some View {
        List {
            ForEach(viewModel.ideas) { idea in
                NavigationLink(destination: IdeaDetailView(idea: idea)) {
                    ideaRow(for: idea)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.delete(idea: idea)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
    
    private func ideaRow(for idea: StartupIdea) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(idea.title).font(.headline)
                Spacer()
                if idea.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
            Text(idea.problem).font(.subheadline)
                .lineLimit(2)
        }
    }
    
    private var addIdeaSheet: some View {
        let addViewModel = AddIdeaViewModel(storage: storage, inspirationUseCase: inspirationUseCase)
        return AddIdeaView(viewModel: addViewModel) {
            Task { await viewModel.load() }
        }
    }
}

// MARK: - Preview Mock Use Case
class MockIdeaInspirationUseCase: IdeaInspirationUseCaseProtocol {
    func execute() async throws -> InspirationData {
        return InspirationData(title: "Mock Title", problem: "Mock Problem", solution: "Mock Solution")
    }
}

// MARK: - Preview
#Preview {
    let testIdea = StartupIdea(title: "Preview Idea", problem: "Test", solution: "Fix")
    let mockStorage = MockStorageService(initialIdeas: [testIdea])
    let viewModel = StartupListViewModel(storage: mockStorage)
    
    StartupListView(
        viewModel: viewModel,
        storage: mockStorage,
        inspirationUseCase: MockIdeaInspirationUseCase()
    )
}
