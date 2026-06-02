// MARK: - StartupList ViewModel Tests

import XCTest
@testable import Startup_Ideas_Tracker
import StorageKit

// MARK: - Test Suite
final class StartupListViewModelTests: XCTestCase {
    
    // MARK: - Loading Tests
    @MainActor
    func testLoadIdeas_Success_ShouldPopulateArray() async {
        let mockStorage = MockStorageService()
        let testIdea = StartupIdea(title: "Тест", problem: "П", solution: "Р")
        try? await mockStorage.save(idea: testIdea)
        
        let viewModel = StartupListViewModel(storage: mockStorage)
        
        await viewModel.load()
        
        XCTAssertEqual(viewModel.ideas.count, 1)
        if case .content = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected state to be .content")
        }
    }
    
    @MainActor
    func testLoadIdeas_Empty() async {
        let mockStorage = MockStorageService()
        let viewModel = StartupListViewModel(storage: mockStorage)
        
        await viewModel.load()
        
        XCTAssertEqual(viewModel.ideas.count, 0)
        if case .empty = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected state to be .empty")
        }
    }
    
    @MainActor
    func testLoadIdeas_Error() async {
        let mockStorage = MockStorageService()
        mockStorage.shouldThrowError = true
        let viewModel = StartupListViewModel(storage: mockStorage)
        
        await viewModel.load()
        
        if case .error(let msg) = viewModel.state {
            XCTAssertEqual(msg, "Test mock error")
        } else {
            XCTFail("Expected state to be .error")
        }
    }
    
    // MARK: - Search Tests
    @MainActor
    func testSearch_FiltersCorrectly() async {
        let mockStorage = MockStorageService()
        let idea1 = StartupIdea(title: "Apples", problem: "Need apples", solution: "")
        let idea2 = StartupIdea(title: "Bananas", problem: "Need bananas", solution: "")
        try? await mockStorage.save(idea: idea1)
        try? await mockStorage.save(idea: idea2)
        
        let viewModel = StartupListViewModel(storage: mockStorage)
        await viewModel.load()
        
        XCTAssertEqual(viewModel.ideas.count, 2)
        
        viewModel.searchText = "App"
        XCTAssertEqual(viewModel.ideas.count, 1)
        XCTAssertEqual(viewModel.ideas.first?.title, "Apples")
        
        viewModel.searchText = "bananas"
        XCTAssertEqual(viewModel.ideas.count, 1)
        XCTAssertEqual(viewModel.ideas.first?.title, "Bananas")
        
        viewModel.searchText = "Orange"
        XCTAssertEqual(viewModel.ideas.count, 0)
    }
    
    // MARK: - Storage Tests
    func testMockStorage_SaveAndDelete() async throws {
        let mockStorage = MockStorageService()
        let idea = StartupIdea(title: "Test Delete", problem: "Test", solution: "Test")
        
        try await mockStorage.save(idea: idea)
        var fetched = try await mockStorage.fetchIdeas()
        XCTAssertEqual(fetched.count, 1)
        
        try await mockStorage.delete(idea: idea)
        fetched = try await mockStorage.fetchIdeas()
        XCTAssertEqual(fetched.count, 0)
    }
    
    // MARK: - Deletion Tests
    @MainActor
    func testDeleteIdea_Success_RemovesIdeaAndUpdatesState() async {
        let mockStorage = MockStorageService()
        let idea1 = StartupIdea(title: "To Delete", problem: "P", solution: "S")
        let idea2 = StartupIdea(title: "To Keep", problem: "P", solution: "S")
        try? await mockStorage.save(idea: idea1)
        try? await mockStorage.save(idea: idea2)
        
        let viewModel = StartupListViewModel(storage: mockStorage)
        await viewModel.load()
        
        XCTAssertEqual(viewModel.ideas.count, 2)
        
        viewModel.delete(idea: idea1)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.ideas.count, 1)
        XCTAssertEqual(viewModel.ideas.first?.title, "To Keep")
        
        viewModel.delete(idea: idea2)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.ideas.count, 0)
        if case .empty = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected state to be .empty")
        }
    }
}
