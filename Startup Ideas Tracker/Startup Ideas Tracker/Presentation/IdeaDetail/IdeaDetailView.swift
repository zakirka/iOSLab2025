// MARK: - Idea Detail View

import SwiftUI
import StorageKit

// MARK: - View Structure
struct IdeaDetailView: View {
    
    // MARK: - Properties
    @Bindable var idea: StartupIdea
    @State private var isShowingShareSheet = false
    
    // MARK: - UI Body
    var body: some View {
        List {
            mainSection
            textSection(header: "Проблема", text: $idea.problem, placeholder: "Опишите проблему")
            textSection(header: "Решение", text: $idea.solution, placeholder: "Опишите решение")
            textSection(header: "Целевая аудитория", text: $idea.audience, placeholder: "Кто ваша аудитория?")
            textSection(header: "Монетизация", text: $idea.monetization, placeholder: "Как будете зарабатывать?")
            ratingSection
            exportSection
        }
        .navigationTitle(idea.title)
        .toolbar {
            toolbarItems
        }
        .sheet(isPresented: $isShowingShareSheet) {
            ShareSheet(activityItems: [idea.exportToMarkdown()])
        }
    }
    
    // MARK: - UI Components
    private var mainSection: some View {
        Section(header: Text("Основное")) {
            Picker("Статус", selection: $idea.status) {
                ForEach(IdeaStatus.allCases) { s in
                    Text(s.rawValue).tag(s)
                }
            }
            .pickerStyle(.menu)
            
            Picker("Приоритет", selection: $idea.priority) {
                ForEach(IdeaPriority.allCases) { p in
                    Text(p.rawValue).tag(p)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    private func textSection(header: String, text: Binding<String>, placeholder: String) -> some View {
        Section(header: Text(header)) {
            TextField(placeholder, text: text, axis: .vertical)
                .lineLimit(1...10)
        }
    }
    
    private var ratingSection: some View {
        Section(header: Text("Оценка")) {
            Stepper("Рейтинг: \(idea.rating) / 5", value: $idea.rating, in: 1...5)
        }
    }
    
    private var exportSection: some View {
        Section {
            Button(action: {
                isShowingShareSheet = true
            }) {
                HStack {
                    Image(systemName: "doc.text")
                    Text("Экспорт в Markdown")
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                Button {
                    isShowingShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Button {
                    idea.isFavorite.toggle()
                } label: {
                    Image(systemName: idea.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(idea.isFavorite ? .red : .gray)
                }
            }
        }
    }
}
