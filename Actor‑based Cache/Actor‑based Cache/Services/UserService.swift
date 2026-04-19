//
//  UserService.swift
//  Actor‑based Cache
//
//  Created by Azamat Zakirov on 18.04.2026.
//

class UserService: UsersServiceProtocol {

    let cache = UsersCache()

    func fetchUsers(ids: [Int]) async throws -> [User] {
        try await withThrowingTaskGroup(of: User.self) { group in
            for id in ids {
                group.addTask {

                    try Task.checkCancellation()

                    if let cachedUser = await self.cache.user(for: id) {
                        return cachedUser
                    }

                    let user = try await self.downloadUser(id: id)

                    try Task.checkCancellation()

                    await self.cache.save(user)

                    return user

                }
            }

            var allUsers: [User] = []
            for try await user in group {
                allUsers.append(user)
            }
            return allUsers

        }
    }

    func fetchUsers() async throws -> [User] {
        return try await fetchUsers(ids: [1, 2, 3, 4, 5])
    }

    private func downloadUser(id: Int) async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return User(id: id, name: "Name \(id)", username: "login\(id)", email: "test\(id)@test.com")
    }
}
