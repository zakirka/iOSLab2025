// MARK: - Add Idea View

import SwiftUI
import StorageKit

// MARK: - View Structure
struct AddIdeaView: View {
    
    // MARK: - Environment & State
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: AddIdeaViewModel
    let onSave: () -> Void
    
    // MARK: - UI Body
    var body: some View {
        NavigationStack {
            Form {
                errorSection
                mainInfoSection
                statusSection
                businessModelSection
                ratingSection
            }
            .navigationTitle("Новая идея")
            .toolbar {
                toolbarLeading
                toolbarTrailing
            }
        }
    }
    
    // MARK: - UI Components
    @ViewBuilder
    private var errorSection: some View {
        if let errorMessage = viewModel.errorMessage {
            Section {
                Text(errorMessage).foregroundColor(.red)
            }
        }
    }
    
    @ViewBuilder
    private var mainInfoSection: some View {
        Section(header: Text("Основная информация")) {
            TextField("Название", text: $viewModel.title)
            TextField("Проблема", text: $viewModel.problem, axis: .vertical)
                .lineLimit(1...10)
            TextField("Решение", text: $viewModel.solution, axis: .vertical)
                .lineLimit(1...10)
        }
    }
    
    @ViewBuilder
    private var statusSection: some View {
        Section(header: Text("Статус и Приоритет")) {
            Picker("Статус", selection: $viewModel.status) {
                ForEach(IdeaStatus.allCases) { s in
                    Text(s.rawValue).tag(s)
                }
            }
            Picker("Приоритет", selection: $viewModel.priority) {
                ForEach(IdeaPriority.allCases) { p in
                    Text(p.rawValue).tag(p)
                }
            }
        }
    }
    
    @ViewBuilder
    private var businessModelSection: some View {
        Section(header: Text("Бизнес-модель")) {
            TextField("Целевая аудитория", text: $viewModel.audience, axis: .vertical)
                .lineLimit(1...10)
            TextField("Монетизация", text: $viewModel.monetization, axis: .vertical)
                .lineLimit(1...10)
        }
    }
    
    @ViewBuilder
    private var ratingSection: some View {
        Section(header: Text("Оценка")) {
            Stepper("Рейтинг: \(viewModel.rating)", value: $viewModel.rating, in: 1...5)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarLeading: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                Task {
                    await viewModel.generateInspiration()
                }
            }) {
                if viewModel.isLoadingInspiration {
                    ProgressView()
                } else {
                    Image(systemName: "sparkles")
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Сохранить") {
                Task {
                    do {
                        try await viewModel.saveIdea()
                        onSave()
                        dismiss()
                    } catch {
                        viewModel.errorMessage = "Ошибка сохранения: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}
